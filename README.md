# python-kasa Docker

This is a Docker image that allows you to run [python-kasa/python-kasa](https://github.com/python-kasa/python-kasa) with a single command.

## Usage

```bash
docker run --rm --network host jtmotox/python-kasa <command>
```

Substitute ```<command>```(optional) with any of the python-kasa commands.

Examples:

&nbsp;--help

&nbsp;--host 192.168.1.200 sysinfo
