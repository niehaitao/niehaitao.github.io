# Application Stack

An [application stack](https://www.techopedia.com/definition/6010/application-stack) is a suite or set of applications that work together to achieve a common goal.

## Prerequisites

|                                               Tool | Check                      |
| -------------------------------------------------: | :------------------------- |
|                  [Docker](https://www.docker.com/) | `docker --version`         |
| [Docker Compose](https://docs.docker.com/compose/) | `docker-compose --version` |

## Activities

**Activities** application stack is composed of front/back/database to show the create/update/delete activities.

You can use `docker-compose -f activities/docker-compose.yml up` to create the stack then see the result on http://localhost:8082/.

<table>
<thead>
  <tr>
    <th colspan="4">Application Architecture </th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="3"><img src="activities/.data/activities.gif" alt="app"  width="200"></td>
    <td colspan="3"><img src=".data/architecture.png" width="600"></td>
  </tr>
  <tr>
    <td>Front End Web</td>
    <td>Back End API</td>
    <td>Database</td>
  </tr>
  <tr>
    <td ><a href="https://github.com/niehaitao/activities-web" target="_blank" rel="noopener noreferrer">activities-web</a></td>
    <td ><a href="https://github.com/niehaitao/activities-api" target="_blank" rel="noopener noreferrer">activities-api</a></td>
    <td ><a href="activities/init-db.sql" target="_blank" rel="noopener noreferrer">activities-database</a></td>
  </tr>
</tbody>
</table>



> Lear more about [How to Build the Activities Stack](activities/README.md)

## Helm Resources

**Helm Resources** application stack is composed of front/back/database to show the create/update/delete activities.
