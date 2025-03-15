package config

type Config struct {
	Port string `env:"PORT" envDefault:"8070"`
	Env  string `env:"ENV" envDefault:"dev"`
}
