# Todo2 Client Application

## Introduction
The Todo2 series of repos on my github are my attempt at following along with [this workshop repo from LINK 2015](https://github.com/Workiva/building-a-workiva-app-workshop).
There are a few differences in the end product to be aware of though:

1. Since I'm not too huge a fan of the language Go, I rewrote (to the best of my abilities, though I do admit to taking a few shortcuts when it came to writing the persister) the backend service in Java.
2. Since it has been a good 5 years since the workshop was written, a decent amount of the dart code and libraries used in both the SDK project and the Client project are out of date.
Because of this, I had to rewrite certain bits in both this repo, and the todo2-sdk repo (mostly was just the bits dealing with the NATS messaging service and whatnot).

There are also probably going to be some stylistic changes that I might make in the future (e.g. UI updates, might add another frugal endpoint, etc.) that will probably result in this project not being a one-to-one port and upgrade of the original workshop.

## Building and Running Todo2 Client Locally
Since (reasonably) the Java server is not deployed to wk-dev or anything, to run the client you will also have to run the backend locally.

To run this, you will need to have these tools/services installed:

- `dart` [\(Click Here for Instructions\)](https://dev.workiva.net/docs/teams/platform/application-frameworks/front-end-dev-training/dart#installation)
- `frugal` [\(Click Here for Instructions\)](https://github.com/Workiva/frugal#installation)
- `gnatsd` (Can be installed by running `brew install gnatsd`)
- `messaging-frontend` [\(Click Here For Instructions\)](https://github.com/Workiva/messaging-frontend#usage)
- `todo2-service` [\(Click Here For Instructions\)](https://github.com/thomasmaloney-wk/todo2-service#running-locally)


One thing you should also do is put 
```bash
export IAM_HOST="https://wk-dev.wdesk.org"
```
in your `.bashrc` or `.zshrc` profile.

Then once everything is set up, run the following commands:

```bash
$ gnatsd

# in another terminal window:
$ messaging-frontend -pubkey-urls="https://wk-dev.wdesk.org/iam/oauth2/v2.0/certs" -dev-mode

# then in yet another terminal window
# in the directory you cloned todo2-service:
$ make serve

# If you want to skip validation, 
# prepend IAM_UNSAFE=true to the above command

# then in another terminal window in 
# the directory you cloned todo2-client:
$ make run
```
You can then view the app in your browser at http://localhost:8080
<!-- 1. Open a terminal and run `gnatsd`
2. Open another terminal and run `messaging-frontend -pubkey-urls="https://wk-dev.wdesk.org/iam/oauth2/v2.0/certs" -dev-mode`
3. Open yet another terminal and navigate to the directory you cloned `todo2-service` and run `mvn exec:java -Dexec.mainClass=com.workiva.todo2.NatsServer`
(optionally set `IAM_UNSAFE=true` to skip validation)
4. Open another terminal and navigate to where ever you cloned this repo and run `make run` -->

## Unit Tests
### Running unit tests
```bash
$ pub run dart_dev test
```

## See Also
- [Todo2 Service Repo](https://github.com/thomasmaloney-wk/todo2-service)
- [Todo2 Dart SDK Repo](https://github.com/thomasmaloney-wk/todo2-sdk)
- [Todo2 Transport (Frugal stuff) Repo](https://github.com/thomasmaloney-wk/todo2-transport)
