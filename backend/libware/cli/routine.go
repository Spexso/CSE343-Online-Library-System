package cli

import (
	"bufio"
	"context"
	"errors"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/Spexso/CSE343-Online-Library-System/backend/libware/database"
)

type Cli struct {
	db  *database.Database
	srv *http.Server
	sc  *bufio.Scanner
}

func New(db *database.Database, srv *http.Server) *Cli {
	sc := bufio.NewScanner(os.Stdin)
	sc.Split(bufio.ScanLines)

	return &Cli{db: db, srv: srv, sc: sc}
}

func (c *Cli) Start() {
	for {
		fmt.Print("> ")
		if !c.sc.Scan() {
			fmt.Println("exit")
			c.cmdExit(nil)
			return
		}

		line := c.sc.Text()
		command, arguments, err := parseLine(line)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			continue
		}

		switch command {
		case "help":
			fmt.Print(
				`exit
admin-insert name=<string> password=<string>
admin-delete id=<integer>
`)
		case "exit":
			err = c.cmdExit(arguments)
			if err == nil {
				return
			}
		case "admin-insert":
			err = c.cmdAdminInsert(arguments)
		}

		if err != nil {
			fmt.Fprintln(os.Stderr, err)
		}
	}
}

func unrecognizedArgument(arg string) error {
	return fmt.Errorf("unrecognized argument %q", arg)
}

func missingArgument(args []string, arguments map[string]string) error {
	for _, arg := range args {
		_, ok := arguments[arg]
		if !ok {
			return fmt.Errorf("missing argument %q", arg)
		}
	}

	return nil
}

func (c *Cli) cmdExit(arguments map[string]string) error {
	if len(arguments) != 0 {
		for k := range arguments {
			unrecognizedArgument(k)
		}
	}

	log.Print("shutdown initiated")
	if err := c.srv.Shutdown(context.Background()); err != nil {
		log.Printf("error: Cli.cmdExit: %v", err)
	}

	return nil
}

func (c *Cli) cmdAdminInsert(arguments map[string]string) error {
	if err := missingArgument([]string{"name", "password"}, arguments); err != nil {
		return err
	}

	var name string
	var password string
	for k, v := range arguments {
		switch k {
		case "name":
			name = v
		case "password":
			password = v
		default:
			return unrecognizedArgument(k)
		}
	}

	_, err := c.db.AdminInsert(name, password)
	if err != nil {
		return err
	}

	log.Printf("admin-insert: %q created", name)

	return nil
}

func parseLine(line string) (string, map[string]string, error) {
	arguments := strings.Split(line, " ")
	if len(arguments) == 0 {
		return "", nil, errors.New("input does not contain command")
	}

	argumentsMap := make(map[string]string)
	command, arguments := arguments[0], arguments[1:]
	for _, v := range arguments {
		key, value, found := strings.Cut(v, "=")
		if !found || len(key) == 0 || len(value) == 0 {
			return command, argumentsMap, fmt.Errorf("malformed argument %q", v)
		}

		_, exists := argumentsMap[key]
		if exists {
			return command, argumentsMap, fmt.Errorf("key %q already exists", key)
		}

		argumentsMap[key] = value
	}

	return command, argumentsMap, nil
}
