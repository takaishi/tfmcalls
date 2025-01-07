package tfmcalls

import (
	"context"
	"fmt"
	"github.com/alecthomas/kong"
	"github.com/hashicorp/terraform-config-inspect/tfconfig"
	"path/filepath"
)

type CLI struct {
	Path string `type:"path" help:"The directory containing the module to inspect."`
}

func RunCLI(ctx context.Context, args []string) {
	var cli CLI
	kctx := kong.Parse(&cli,
		kong.Name("tfmcalls"),
		kong.Description("Recursively retrieve and output the modules that the specified module depends on."))
	kctx.FatalIfErrorf(App(&cli))
}

func App(cli *CLI) error {
	modules := getModuleCalls(cli.Path)

	for _, m := range removeDuplicates(modules) {
		fmt.Printf("%s\n", m)
	}

	return nil
}

func getModuleCalls(dir string) []string {
	var calls []string
	module, _ := tfconfig.LoadModule(dir)

	for _, call := range module.ModuleCalls {
		dependencies := getModuleCalls(filepath.Join(dir, call.Source))
		for _, d := range dependencies {
			calls = append(calls, d)
		}
		calls = append(calls, filepath.Join(dir, call.Source))
	}

	return calls
}

func removeDuplicates(elements []string) []string {
	encountered := map[string]bool{}
	var result []string

	for _, v := range elements {
		if !encountered[v] {
			encountered[v] = true
			result = append(result, v)
		}
	}

	return result
}
