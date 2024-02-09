CREATE TABLE IF NOT EXISTS Utilisateurs (           
  id INT AUTO_INCREMENT NOT NULL,
  Nom VARCHAR(255),
  Email VARCHAR(255),
  Date_inscription DATE,
  PRIMARY KEY (id)
) ENGINE=InnoDB;     

INSERT INTO Utilisateurs(Nom, Email, Date_inscription) VALUES('Yann', 'yann@hotmail.com', '2024-02-05');
INSERT INTO Utilisateurs(Nom, Email, Date_inscription) VALUES('David', 'david@hotmail.com', '2024-02-06');
INSERT INTO Utilisateurs(Nom, Email, Date_inscription) VALUES('Dorian', 'dorian@hotmail.com', '2024-02-07');

CREATE TABLE IF NOT EXISTS Connexions (           
  Connexion_id INT AUTO_INCREMENT NOT NULL,
  Utilisateur_id INT,
  Timestamp TIMESTAMP,
  PRIMARY KEY (Connexion_id),
  FOREIGN KEY (Utilisateur_id) REFERENCES Utilisateurs(id)
) ENGINE=InnoDB;

INSERT INTO Connexions(Utilisateur_id, `Timestamp`) VALUES((SELECT id from Utilisateurs WHERE Nom='Yann'), NOW());
INSERT INTO Connexions(Utilisateur_id, `Timestamp`) VALUES((SELECT id from Utilisateurs WHERE Nom='David'), NOW());
INSERT INTO Connexions(Utilisateur_id, `Timestamp`) VALUES((SELECT id from Utilisateurs WHERE Nom='Dorian'), NOW());
