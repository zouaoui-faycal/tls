# Utilisez l'image officielle de Go pour construire l'application
FROM golang:latest AS builder

# Copiez le code source dans le conteneur
WORKDIR /app
COPY . .


# Construisez l'application Go
RUN go mod init monapp && go build -o monapp

# Utilisez une image minimale pour le conteneur final
FROM golang:latest

# Copiez l'exécutable depuis le constructeur vers le conteneur final
WORKDIR /app
COPY --from=builder /app/monapp .

# Copiez également les fichiers de certificat TLS (remplacez les chemins si nécessaire)
COPY certificat.pem .
COPY cle-privée.pem .
RUN chmod +x monapp

# Exposez le port sécurisé de l'application
EXPOSE 8443

# Commande pour exécuter l'application au démarrage du conteneur
CMD ["./monapp"]
