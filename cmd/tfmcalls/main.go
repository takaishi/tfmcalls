package main

import (
	"context"
	"github.com/takaishi/tfmcalls"
	"os"
	"os/signal"
)

func main() {
	ctx := context.TODO()
	ctx, stop := signal.NotifyContext(ctx, []os.Signal{os.Interrupt}...)
	defer stop()
	tfmcalls.RunCLI(ctx, os.Args[1:])
}
