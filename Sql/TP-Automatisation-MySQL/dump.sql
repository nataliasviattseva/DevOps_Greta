-- DELETE FROM Utilisateurs IF EXISTS;
-- DELETE FROM Connexions IF EXISTS;

CREATE TABLE IF NOT EXISTS Utilisateurs (           
  id serial primary key NOT NULL,
  Nom (VARCHAR),
  Email (VARCHAR),
  "Date inscription" (DATE),
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;     

INSERT INTO Utilisateurs(Nom, Email, "Date inscription") VALUES('Yann', 'yann@hotmail.com', '05/02/24');

INSERT INTO Utilisateurs(Nom, Email, "Date inscription") VALUES('David', 'david@hotmail.com', '06/02/24');

INSERT INTO Utilisateurs(Nom, Email, "Date inscription") VALUES('Dorian', 'dorian@hotmail.com', '07/02/24');


CREATE TABLE IF NOT EXISTS Connexions (           
  Connexion_id serial primary key NOT NULL,
  FOREIGN KEY Utilisateur_id REFERENCES Utilisateurs(id),
  Timestamp  (TIMESTAMP),
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8;     

INSERT INTO Connexions(Utilisateur_id, Timestamp) VALUES((SELECT id from Utilisateurs WHERE Nom='Yann'), TIMESTAMP(NOW()));

INSERT INTO Connexions(Utilisateur_id, Timestamp) VALUES((SELECT id from Utilisateurs WHERE Nom='David'), TIMESTAMP(NOW()));

INSERT INTO Connexions(Utilisateur_id, Timestamp) VALUES((SELECT id from Utilisateurs WHERE Nom='Dorian'), TIMESTAMP(NOW()));

