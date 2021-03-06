package hostname

import (
	"io/ioutil"
	"syscall"
)

func SetHostname(hostname string) error {
	if err := syscall.Sethostname([]byte(hostname)); err != nil {
		return err
	}
	return ioutil.WriteFile("/etc/hostname", []byte(hostname), 0644)
}
