# Laboratorio WrongSecrets con Docker Compose: practica cómo encontrar secretos escritos en el código y errores de gestión de secretos con OWASP WrongSecrets

[English](README.md) | [Français](README.fr.md) | [日本語](README.ja.md) | [Español](README.es.md)

[![check](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml)

Un **laboratorio de gestión de secretos** listo para el aula, de la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning), donde escuelas y centros dan a cada alumno sus propias bases de datos, sus propios contenedores y su propio terminal en el navegador. Cada alumno recibe su propia copia de **OWASP WrongSecrets**, una aplicación que esconde mal a propósito secretos falsos, en su código, sus páginas web y su configuración, para practicar **cómo encontrar secretos escritos en el código** y después explicar dónde debería haberse guardado un secreto. No se instala nada y no se pone en riesgo el equipo de nadie más.

Es un único archivo `docker-compose`, `compose.yaml`, y funciona igual en tu propio equipo que en la plataforma, donde cada alumno tiene una copia privada sin salida a internet.

## La única regla

**Mira dentro de tu propia copia y nada más.** Todo en este laboratorio se ejecuta dentro de tu propia copia privada, que no tiene ruta a internet ni a ningún otro alumno, así que lo único que puedes alcanzar es la aplicación que el laboratorio inició para ti. Nunca apuntes una herramienta a un sitio web, una red o una máquina que no sean tuyos, en un laboratorio o en cualquier otro sitio: en el Reino Unido eso es un delito según la [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), y la mayoría de los países tienen una ley parecida. Los secretos de esta aplicación son inventados, y acostumbrarse a buscar los de verdad en el repositorio de otra persona no es un juego: una buena primera conversación en clase es por qué existe esta regla y cómo es una divulgación responsable.

## Qué contiene

| Servicio | Imagen | Memoria | Qué es |
| --- | --- | --- | --- |
| `wrongsecrets` | [`jeroenwillemsen/wrongsecrets:1.14.1-no-vault`](https://hub.docker.com/r/jeroenwillemsen/wrongsecrets) | 512 MB | la aplicación web WrongSecrets, en el puerto 8080 |

La imagen es la compilación `no-vault` del propio proyecto, así que no necesita ningún servidor Vault ni ninguna cuenta en la nube. Se ejecuta con una cuenta sin privilegios (usuario 2000) y no necesita capacidades. Arranca en unos segundos, una vez que la imagen está en la máquina, y usa aproximadamente 235 MB en reposo. La imagen es grande, unos 550 MB de descarga, así que el primer arranque en una máquina nueva tarda más.

La imagen es un programa de terceros, ejecutado sin modificar a partir de la imagen pública del propio proyecto y fijado a una versión (nunca `latest`), así que el laboratorio no cambia bajo los pies de una clase de una lección a la siguiente. Aquí no se compila nada y nada de este repositorio se distribuye en ella.

## Usarlo en la plataforma

La [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning) da a cada alumno su propia copia de un laboratorio, en el navegador, con un terminal al lado.

**Para probarlo:** abre la [página de contenedores](https://mitsurutech.co.uk/es/container), busca este laboratorio en **Laboratorios de ejemplo** y pulsa Iniciar. No hace falta cuenta para probar uno.

**Para ponerlo como trabajo a una clase:**

1. En tu módulo, crea una tarea de tipo **Laboratorio** y elige **En un repositorio de GitHub**.
2. Indica `https://github.com/mitsurutech/lab-wrongsecrets` con la rama `main`. El archivo compose es el predeterminado, `compose.yaml`. Haz antes un fork del repositorio si quieres cambiar el archivo.
3. Publica. La copia de cada alumno parte del commit que publicaste, así que un cambio posterior aquí no altera un laboratorio ya puesto.
4. Di en la tarea qué hay que entregar (consulta [Para profesores](#para-profesores)) y asígnala como cualquier otra tarea.

La [guía de este laboratorio](https://mitsurutech.co.uk/es/help/lab-wrongsecrets), la [guía de los laboratorios de seguridad](https://mitsurutech.co.uk/es/help/security-labs) y la [guía de laboratorios de contenedores](https://mitsurutech.co.uk/es/help/labs) del manual de ayuda cuentan el resto: qué puede decir un archivo compose, cuánta memoria recibe una copia y cómo abre, observa y califica un profesor la copia de un alumno.

¿Aún no tienes una cuenta de centro? [El primer año es gratis](https://mitsurutech.co.uk/es/pricing) para hasta 50 alumnos, y [registrarse](https://mitsurutech.co.uk/es/signup) solo pide una dirección de correo electrónico.

## Ejecutarlo en tu propio equipo

Necesitas Docker con el complemento Compose. El primer arranque descarga la imagen.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Abre <http://localhost:8080>. No hay que crear ninguna cuenta: elige un reto en el menú **Challenges**.

`local.yaml` publica el puerto solo en `127.0.0.1`, así que el laboratorio es accesible desde tu propio ordenador y desde ningún otro sitio. Deténlo con `Ctrl-C` y elimínalo con `docker compose -f compose.yaml -f local.yaml down -v`.

## Cómo trabajarlo

1. **Empieza por el Challenge 0.** Explica el juego: cada reto consiste en encontrar un secreto que no se ha escondido o configurado bien, y luego escribirlo y pulsar Submit. Su propia respuesta está en la página.
2. **Lee el enunciado y las pistas.** Cada reto dice de qué tipo de debilidad trata y tiene pistas que puedes abrir cuando te atascas.
3. **Mira donde miraría un desarrollador o un atacante.** En este laboratorio eso es la propia página y las herramientas de desarrollo del navegador, y el terminal junto al laboratorio, donde `curl` llega a la aplicación por el nombre `wrongsecrets` en el puerto 8080. Por ejemplo, el Challenge 16 trata de un secreto dejado en código de front-end, y el Challenge 42 de lo que revelan los puntos de acceso de monitorización de una aplicación.
4. **Explícalo.** Por cada secreto que encuentres, di dónde estaba, cómo lo encontraste, por qué ese lugar está mal y dónde debería guardarse un secreto.

## Para profesores

Nada en este laboratorio se califica automáticamente, salvo la marca verde de la propia aplicación para una respuesta correcta. El alumno entrega pruebas y tú las calificas, igual que cualquier otro laboratorio.

**Pide pruebas en dos mitades.** Primero, la prueba del trabajo: una captura de pantalla de cada reto resuelto, con la dirección del propio laboratorio visible en el navegador para que quede claro que es su copia. Segundo, la comprensión: para cada uno, una explicación escrita con sus propias palabras de dónde estaba el secreto, cómo lo encontraron, por qué ese lugar está mal y qué debería hacer un equipo en su lugar (un gestor de secretos, configuración de entorno fuera de la imagen, búsqueda de secretos antes de un commit). La segunda mitad te dice si se entendió o se copió de una guía paso a paso.

**Dónde encaja en un curso.** WrongSecrets encaja en unidades de programación segura, DevOps y cadena de suministro de software: credenciales en el código y en el control de versiones, en imágenes de contenedores y en la configuración, en código de front-end, y en registros y monitorización. Consulta la redacción exacta en la unidad de tu propio organismo de certificación; aquí no se cita ninguna.

**Quién ve qué.** Estos laboratorios se usan a menudo con alumnos de 16 y 17 años. Una copia es privada para el alumno que la inició. Un miembro del personal que imparte el módulo puede abrirla para ver lo que ha hecho el alumno, y abrir el trabajo de un alumno queda escrito en el registro de accesos, que el alumno puede leer.

## Qué no funciona en un laboratorio

**Solo algunos retos se pueden resolver aquí, y eso es por el diseño del laboratorio, no un fallo.** Una copia del laboratorio no tiene salida a internet, y la aplicación es lo único que hay en ella. Los retos que piden clonar el repositorio del proyecto desde GitHub, abrir un shell dentro del contenedor de la propia aplicación, usar una cuenta en la nube, Vault o Kubernetes, o hablar con un servicio de IA o con un sitio web de otro lugar no se pueden hacer. Los que tratan de la propia página, de los puntos de acceso de la aplicación y de lo que descarga el navegador sí: los Challenges 0, 16 y 42 los comprueban las pruebas de este repositorio. La imagen `no-vault` no tiene ninguno de los retos de Vault. La aplicación no guarda nada: detener el laboratorio y volver a iniciarlo es un juego nuevo, sin recordar ningún reto resuelto.

## Solución de problemas

- **La página no aparece justo después de Iniciar.** Espera unos segundos y vuelve a pulsar Abrir: el laboratorio se declara listo cuando la aplicación responde en su dirección de comprobación de estado.
- **Un reto dice que necesita algo que el laboratorio no tiene.** Es uno de los retos descritos arriba; elige otro.
- **En tu propio equipo, el puerto 8080 ya está en uso.** Cambia el número de la izquierda en `local.yaml`, por ejemplo `127.0.0.1:8081:8080`, y abre ese puerto en su lugar.

## Comprobación del laboratorio

`test/check.sh` inicia el laboratorio como el ejecutor de la plataforma inicia cada servicio (todas las capacidades retiradas, `no-new-privileges`, un límite de procesos, límites de memoria y ninguna salida a internet) y luego comprueba desde dentro de su red lo que promete esta página. Necesita Docker y se ejecuta en cada push, que es la insignia de arriba.

```bash
test/check.sh
```

## Versiones y licencias

[OWASP WrongSecrets](https://github.com/OWASP/wrongsecrets) tiene licencia GNU Affero General Public License v3.0 (AGPL-3.0). La imagen es `jeroenwillemsen/wrongsecrets` con la etiqueta `1.14.1-no-vault`. Se usa aquí sin modificar, a partir de su propia imagen pública, y no se redistribuye.

## Licencia

Esta obra está bajo licencia [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Puedes compartirla y adaptarla para aprender y enseñar, si citas a Mitsuru Technologies Ltd, no la usas comercialmente y compartes lo que hagas con ella bajo la misma licencia. El texto completo está en el archivo `LICENSE`.

La aplicación que contiene conserva la licencia de su propio proyecto, enlazada arriba.

## Acerca de

Hecho por [Mitsuru Technologies](https://mitsurutech.co.uk/es) para la [plataforma de aprendizaje MitsuruTech](https://mitsurutech.co.uk/es/learning): Python, Java, Go, Node, SQL y Linux en el navegador para escuelas y centros, con laboratorios de contenedores, aplicaciones web desplegadas desde GitHub y cuestionarios que se califican solos. Prueba código sin cuenta en el [entorno de pruebas](https://mitsurutech.co.uk/es/playground).

Más laboratorios del mismo sitio: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) y [lab-sample](https://github.com/mitsurutech/lab-sample).
