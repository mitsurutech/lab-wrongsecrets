# WrongSecrets lab with Docker Compose: practise finding hardcoded secrets and secrets management mistakes with OWASP WrongSecrets

[![check](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml/badge.svg)](https://github.com/mitsurutech/lab-wrongsecrets/actions/workflows/check.yml)

A ready-made **secrets management lab** for classrooms, from the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning), where schools and colleges give every student their own databases, containers and terminal in the browser. Each student gets their own copy of **OWASP WrongSecrets**, an application that hides fake secrets badly on purpose, in its code, its web pages and its configuration, to practise **finding hardcoded secrets** and then explaining where a secret should have been kept instead. Nothing is installed and nobody else's machine is at risk.

It is one `docker-compose` file, `compose.yaml`, and it runs the same on your own machine as it does on the platform, where every student gets a private copy with no way out to the internet.

## The one rule

**Look into your own copy and nothing else.** Everything in this lab runs inside your own private copy, which has no route to the internet and none to any other student, so the only thing you can reach is the application the lab started for you. Never point a tool at a website, a network or a machine you do not own, in a lab or anywhere else: in the UK that is an offence under the [Computer Misuse Act 1990](https://www.legislation.gov.uk/ukpga/1990/18/contents), and most countries have a law like it. The secrets in this application are made up, and the habit of looking for the real ones in somebody else's repository is not a game: a good first conversation in a class is why this rule exists and what responsible disclosure looks like.

## What is in it

| Service | Image | Memory | What it is |
| --- | --- | --- | --- |
| `wrongsecrets` | [`jeroenwillemsen/wrongsecrets:1.14.1-no-vault`](https://hub.docker.com/r/jeroenwillemsen/wrongsecrets) | 512 MB | the WrongSecrets web application, on port 8080 |

The image is the project's own `no-vault` build, so it needs no Vault server and no cloud account. It runs as an unprivileged account (user 2000) and needs no capabilities. It starts in a few seconds, once the image is on the machine, and uses roughly 235 MB when idle. The image is large, about 550 MB to download, so the first start on a new machine takes longer.

The image is a third-party program, run unmodified from the project's own public image and pinned to a release (never `latest`), so the lab does not change under a class between one lesson and the next. Nothing is built here and nothing from this repository is distributed in it.

## Using it on the platform

The [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning) gives every student their own copy of a lab, in the browser, with a terminal beside it.

**To try it:** open the [container page](https://mitsurutech.co.uk/container), find this lab in **Sample labs** and press Start. No account is needed to try one.

**To set it as work for a class:**

1. In your module, make a task of type **Lab** and choose **In a GitHub repository**.
2. Give `https://github.com/mitsurutech/lab-wrongsecrets` with the branch `main`. The compose file is the default, `compose.yaml`. Fork the repository first if you want to change the file.
3. Publish. Every student's copy starts from the commit you published, so a later change here does not alter a lab already set.
4. Say in the task what to hand in (see [For teachers](#for-teachers)), and assign it like any other task.

The help manual's [guide to this lab](https://mitsurutech.co.uk/help/lab-wrongsecrets), its [guide to the security labs](https://mitsurutech.co.uk/help/security-labs) and its [guide to container labs](https://mitsurutech.co.uk/help/labs) cover the rest: what a compose file may say, how much memory a copy gets, and how a teacher opens, watches and marks a student's copy.

No college account yet? [Your first year is free](https://mitsurutech.co.uk/pricing) for up to 50 students, and [signing up](https://mitsurutech.co.uk/signup) takes an email address.

## Running it on your own machine

You need Docker with the Compose plugin. The first start downloads the image.

```bash
docker compose -f compose.yaml -f local.yaml up
```

Open <http://localhost:8080>. There is no account to make: pick a challenge from the **Challenges** menu.

`local.yaml` publishes the port on `127.0.0.1` only, so the lab is reachable from your own computer and from nowhere else. Stop it with `Ctrl-C`, and remove it with `docker compose -f compose.yaml -f local.yaml down -v`.

## Working through it

1. **Start with Challenge 0.** It explains the game: every challenge is about finding one secret that has not been hidden or configured well, then typing it in and pressing Submit. Its own answer is on the page.
2. **Read the task and the hints.** Each challenge says what kind of weakness it is about and has hints you can open when you are stuck.
3. **Look where a developer or an attacker would.** In this lab that is the page itself and the browser's developer tools, and the terminal beside the lab, where `curl` reaches the application by the name `wrongsecrets` on port 8080. For example, Challenge 16 is about a secret left in front-end code, and Challenge 42 about what an application's monitoring endpoints give away.
4. **Explain it.** For each secret you find, say where it was, how you found it, why that place is wrong and where a secret should be kept.

## For teachers

Nothing in this lab is marked automatically beyond the application's own green tick for a right answer. The student hands in evidence and you mark it, the way you mark any other lab.

**Ask for evidence in two halves.** First, proof of the work: a screenshot of each challenge solved, with the lab's own address visible in the browser so it is clearly their copy. Second, the understanding: for each one, a written explanation in their own words of where the secret was, how they found it, why that place is wrong, and what a team should do instead (a secrets manager, environment configuration kept out of the image, scanning for secrets before a commit). The second half tells you whether it was understood or copied from a walkthrough.

**Where it sits in a course.** WrongSecrets suits secure coding, DevOps and software supply chain units: credentials in code and in version control, in container images and configuration, in front-end code, and in logs and monitoring. Check your own awarding body's unit for the exact wording; none is quoted here.

**Who sees what.** These labs are often used with students aged 16 and 17. A copy is private to the student who started it. A member of staff who teaches the module can open it to see what the student has done, and opening a student's work is written to the access log, which the student can read.

## What does not work in a lab

**Only some of the challenges can be solved here, and that is by design of the lab, not a fault.** A lab copy has no way out to the internet, and the application is the only thing in it. The challenges that ask you to clone the project's repository from GitHub, to open a shell inside the application's own container, to use a cloud account, Vault or Kubernetes, or to talk to an AI service or a website elsewhere cannot be done. Challenges that are about the page itself, the application's own endpoints and what the browser downloads can: Challenges 0, 16 and 42 are checked by this repository's tests. The `no-vault` image has none of the Vault challenges. The application keeps nothing: stopping the lab and starting it again is a fresh game, with no solved challenges remembered.

## Troubleshooting

- **The page does not appear straight after Start.** Wait a few seconds and press Open again: the lab reports itself ready once the application answers its health address.
- **A challenge says it needs something the lab does not have.** That is one of the challenges described above; pick another.
- **On your own machine, port 8080 is already in use.** Change the left-hand number in `local.yaml`, for example `127.0.0.1:8081:8080`, and open that port instead.

## Checking the lab

`test/check.sh` starts the lab the way the platform's runner starts every service (all capabilities dropped, `no-new-privileges`, a process limit, memory limits, and no way out to the internet) and then checks from inside its network what this page promises. It needs Docker and runs on every push, which is the badge at the top.

```bash
test/check.sh
```

## Versions and licences

[OWASP WrongSecrets](https://github.com/OWASP/wrongsecrets) is licensed under the GNU Affero General Public License v3.0 (AGPL-3.0). The image is `jeroenwillemsen/wrongsecrets` at the tag `1.14.1-no-vault`. It is used here unmodified from its own public image and is not redistributed.

The compose file, the tests and this documentation are MIT licensed, see [LICENSE](LICENSE): copy it, change it, teach with it. The application inside is the licence of its own project, linked above.

## About

Made by [Mitsuru Technologies](https://mitsurutech.co.uk) for the [MitsuruTech Learning Platform](https://mitsurutech.co.uk/learning): Python, Java, Go, Node, SQL and Linux in the browser for schools and colleges, with container labs, web apps deployed from GitHub, and quizzes that mark themselves. Try code with no account in the [playground](https://mitsurutech.co.uk/playground).

More labs from the same place: [lab-juice-shop](https://github.com/mitsurutech/lab-juice-shop), [lab-dvwa](https://github.com/mitsurutech/lab-dvwa), [lab-webgoat](https://github.com/mitsurutech/lab-webgoat), [lab-mysql-phpmyadmin](https://github.com/mitsurutech/lab-mysql-phpmyadmin), [lab-git-gitea](https://github.com/mitsurutech/lab-git-gitea) and [lab-sample](https://github.com/mitsurutech/lab-sample).
