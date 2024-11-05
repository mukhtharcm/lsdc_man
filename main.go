package main

import (
	"log"
	"os"
	"strings"

	"github.com/pocketbase/pocketbase"
	"github.com/pocketbase/pocketbase/apis"
	"github.com/pocketbase/pocketbase/core"
	"github.com/pocketbase/pocketbase/plugins/jsvm"
	"github.com/pocketbase/pocketbase/plugins/migratecmd"
)

func main() {
	app := pocketbase.New()

	// Check if running with go run (for development)
	isGoRun := strings.HasPrefix(os.Args[0], os.TempDir())

	// Register migration command
	migratecmd.MustRegister(app, app.RootCmd, migratecmd.Config{
		// Enable auto creation of migration files during development
		Automigrate:  isGoRun,
		TemplateLang: "js",
	})

	// Load JavaScript migrations and hooks
	jsvm.MustRegister(app, jsvm.Config{
		// Directory containing JavaScript migrations and hooks
		MigrationsDir: "pb_migrations",
		HooksDir:      "pb_hooks",
	})

	// Serve static files from pb_public directory
	app.OnBeforeServe().Add(func(e *core.ServeEvent) error {
		e.Router.GET("/*", apis.StaticDirectoryHandler(os.DirFS("pb_public"), false))
		return nil
	})

	if err := app.Start(); err != nil {
		log.Fatal(err)
	}
}
