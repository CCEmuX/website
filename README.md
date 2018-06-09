# CCEmuX website
This contains the tools for managing the CCEmuX website and generating the
downloads.

## Getting started
Due to the use of several unix command line tools, we do recommend using Linux
when working with the site.

 - `git clone https://github.com/CCEmuX/website.git ccemux-site && cd
   ccemux-site`: Clone the repository
 - `npm install`: Install the node dependencies.
 - `./build`: Build an initial set of CCEmuX downloads.
 - `make serve`: Start a server on port 8080. This will watch for further
   changes to the template and styles, ensuring everything is rebuild.

The `./build` script can be run at any time. It'll fetch the latest version of
CCEmuX and rebuild it if needed, regenerating the website with the updated
download links. It should be run before every deploy to ensure the template
information is up-to-date.
