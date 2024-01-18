package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Bienvenue sur mon serveur sécurisé !")
}

func main() {
	// Gestionnaire de route
	http.HandleFunc("/", handler)

	// Configuration TLS
	server := &http.Server{
		Addr: ":8443", // Port sécurisé
	}

	// Démarrer le serveur avec le support TLS
	err := server.ListenAndServeTLS("./tls.wedreamteam.com.pem", "./tls.wedreamteam.com.key")
	if err != nil {
		log.Fatal("Erreur lors du démarrage du serveur TLS : ", err)
	}
}
