<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/josemv3/HypnoLoops">
    <img src="Hypno\ Loops/Assets.xcassets/AppIcon 1.appiconset/256.png" alt="Logo" width="80" height="80">
  </a>

<h3 align="center">Carpooly App</h3>

  <p align="center">
    <br />
    <a href="https://github.com/kensonjohnson/carpooly/issues">Report Bug</a>
    ·
    <a href="https://github.com/kensonjohnson/carpooly/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <!-- <li><a href="#usage">Usage</a></li> -->
    <!-- <li><a href="#roadmap">Roadmap</a></li> -->
    <!-- <li><a href="#contributing">Contributing</a></li> -->
    <li><a href="#about-us">About Us</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <!-- <li><a href="#acknowledgments">Acknowledgments</a></li> -->
  </ol>
</details>

## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

We are a small group of self taught developers

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With:

![HTML]
![CSS]
![JavaScript]
[![Vite][vite]][vite-url]  
 [![Mongo][mongodb]][mongodb-url]
[![Express][express]][express-url]
[![Passport][passport]][passport-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Getting Started

This is an example of how you may give instructions on setting up your project locally.
To get a local copy up and running follow these simple example steps.

<br />

## Installation

<br />

Clone the repo:

```sh
git clone https://github.com/kensonjohnson/carpooly.git
```

<br />

### Web Instructions

<br />

1. You'll need node version 18 or higher.

```sh
   npm install npm@latest -g
```

2. Move to the Web Project folder.

```sh
   cd web
```

3. Install dependencies.

```sh
   npm install
```

4. Run the develpment server

```
   npm run dev
```

<br />

### Web Cont: Prepare MongoDB Connection File

Create a file in the root directory called .env and add the following:

```
DB_CLUSTER_NAME=YOUR_CLUSTER_ADDRESS
DB_NAME=YOUR_DB_NAME
DB_USER=YOUR_DB_USERNAME
DB_PASSWORD=YOUR_DB_USER_PASSWORD
PORT=YOUR_PORT_CHOICE
```

Replace YOUR_CLUSTER_ADDRESS with your MongoDB URI, local or Atlas information.
Replace YOUR_DB_NAME with the database on that cluster you want to use.
Replace YOUR_DB_USERNAME and YOUR_DB_USER_PASSWORD with admin user info for that database.
Replace YOUR_PORT_CHOICE with whatever port you want to use. You can just use 5000 if you're in development.

If you're using Mongo Atlas, you should add 0.0.0.0/0 to the allowed IP list until development is done. REMEMBER TO CHANGE THIS TO YOUR SERVER IP UPON DEPLOYMENT.

### Mobile Instructions

1. TBD

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.

_For more examples, please refer to the [Documentation](https://example.com)_

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Roadmap

- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3
  - [ ] Nested Feature

See the [open issues](https://github.com/kensonjohnson/carpooly/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p> -->

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

## About Us

We are a small group of self taught developers expanding our skillsets!

## Contact

Project Link: [Carpooly](https://github.com/kensonjohnson/carpooly)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[html]: https://img.shields.io/badge/HTML-20232A?style=for-the-badge&logo=html5&logoColor=#E34F26
[css]: https://img.shields.io/badge/CSS-20232A?style=for-the-badge&logo=css3&logoColor=#1572B6
[javascript]: https://img.shields.io/badge/Javascript-20232A?style=for-the-badge&logo=javascript&logoColor=#F7DF1E
[vite]: https://img.shields.io/badge/Vite-20232A?style=for-the-badge&logo=vite&logoColor=#646CFF
[vite-url]: https://vitejs.dev/
[mongodb]: https://img.shields.io/badge/MongoDB-20232A?style=for-the-badge&logo=mongodb&logoColor=#47A248
[mongodb-url]: https://mongodb.com/
[express]: https://img.shields.io/badge/Express-20232A?style=for-the-badge&logo=express&logoColor=#000000
[express-url]: https://expressjs.com/
[passport]: https://img.shields.io/badge/Passport-20232A?style=for-the-badge&logo=passport&logoColor=#34E27A
[passport-url]: https://www.passportjs.org/
