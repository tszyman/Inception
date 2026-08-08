_This project has been created as part of the 42 curriculum by tszymans._

# Description

_Section that clearly presents the project, including its goal and a
brief overview._

# Instructions

_Section containing any relevant information about compilation,
installation, and/or execution._

Makefile

Command to know:

`make` builds and launches the project.
`make down` stops containers.
`make clean` stops the stack safely.
`make fclean` removes containers, volumes, and images if required.
`make re` rebuilds everything from scratch.

MariaDB
Commands to know:

```bash
docker logs mariadb
docker exec -it mariadb mariadb -u root -p
```

# Resources

_Section listing classic references related to the topic (documentation, articles, tutorials, etc.), as well as a description of how AI was used — specifying for which tasks and which parts of the project._

## AI usage

AI has been used to clarify the goals of the project as well as to explain several issues regarding configuration.

## Project description

## Docker and included sources explanation

## Main design choices

## Comparisons

### Virtual Machines vs Docker

### Secrets vs Environment Variables

### Docker Network vs Host Network

### Docker Volumes vs Bind Mounts