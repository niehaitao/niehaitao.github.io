# Application Stack

An [application stack](https://www.techopedia.com/definition/6010/application-stack) is a suite or set of applications that work together to achieve a common goal.

## Prerequisites

|                                               Tool | Check                      |
| -------------------------------------------------: | :------------------------- |
|                  [Docker](https://www.docker.com/) | `docker --version`         |
| [Docker Compose](https://docs.docker.com/compose/) | `docker-compose --version` |

## Activities

**Activities application stack** is composed of front/back/database to show the create/update/delete activities.
You can use `docker-compose -f activities/docker-compose.yml up` to create the stack then open http://localhost:8082/ to see the result.


<style type="text/css">
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-3z8p{background-color:#329a9d;border-color:inherit;color:#ffffff;
  font-family:"Comic Sans MS", cursive, sans-serif !important;;font-size:18px;text-align:center;vertical-align:middle}
.tg .tg-84k0{background-color:#329a9d;border-color:inherit;color:#ffffff;
  font-family:"Comic Sans MS", cursive, sans-serif !important;;font-size:22px;text-align:center;vertical-align:middle}
.tg .tg-v9k2{border-color:inherit;font-family:"Comic Sans MS", cursive, sans-serif !important;;text-align:center;
  vertical-align:middle}
</style>
<table class="tg">
<thead>
  <tr>
    <th class="tg-84k0" colspan="4">Application Architecture </th>
  </tr>
</thead>
<tbody>
  <tr>
    <td class="tg-v9k2" rowspan="3"><img src="activities/.data/activities.gif" alt="app"  height="300"></td>
    <td class="tg-v9k2" colspan="3"><img src=".data/architecture.png" height="200"></td>
  </tr>
  <tr>
    <td class="tg-3z8p">Front End Web</td>
    <td class="tg-3z8p">Back End API</td>
    <td class="tg-3z8p">Database</td>
  </tr>
  <tr>
    <td class="tg-v9k2"><a href="https://github.com/niehaitao/activities-web" target="_blank" rel="noopener noreferrer">activities-web</a></td>
    <td class="tg-v9k2"><a href="https://github.com/niehaitao/activities-api" target="_blank" rel="noopener noreferrer">activities-api</a></td>
    <td class="tg-v9k2"><a href="activities/init-db.sql" target="_blank" rel="noopener noreferrer">activities-database</a></td>
  </tr>
</tbody>
</table>



> Lear more about [How to Build the Activities Stack](activities/README.md)

## Helm Resources
