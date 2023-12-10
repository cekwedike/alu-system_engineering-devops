# Web Stack Debugging - Part 0

In this repository, we will walk through a series of steps to debug a basic web stack, which consists of a Docker container running an Apache server and serving a "Hello Holberton!" page.

## Steps

1. First, navigate to the root directory of your web stack.

2. Use the following command to build and run the Docker container:
docker build -t web_stack_debugging_0 . docker run -d -p 8080:80 web_stack_debugging_0


3. After running the Docker container, curl the port 8080 to see the output of the "Hello Holberton!" page:
curl 0:8080
