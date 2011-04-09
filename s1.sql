PROMPT Creation des tables
SET ECHO ON
--SPOOL output.txt



DROP SEQUENCE sequence_client
/
DROP SEQUENCE sequence_fournisseur
/
DROP SEQUENCE sequence_commande
/
DROP SEQUENCE sequence_FactureLivraison
/



DROP TABLE Catalogue
/
DROP TABLE Priorite
/
DROP TABLE Fournisseur
/
DROP TABLE PaiementCheque
/
DROP TABLE PaiementCarteCredit
/
DROP TABLE LigneLivraison
/
DROP TABLE FactureLivraison
/
DROP TABLE LigneCommande
/
DROP TABLE Item
/
DROP TABLE Produit
/
DROP TABLE Commande
/
DROP TABLE Client
/
DROP TABLE Adresse
/



ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY/MM/DD'
/



CREATE TABLE Client
(noClient           INTEGER             NOT NULL,
 motDePasse         VARCHAR(20)         NOT NULL,
 nom                VARCHAR(20)         NOT NULL,
 prenom             VARCHAR(20)         NOT NULL,
 plusGrandeQualite  VARCHAR(20)         NOT NULL,
 telephone          VARCHAR(10)         NOT NULL,
 PRIMARY KEY (noClient)
)
/
CREATE TABLE Adresse
(noClient           INTEGER                 NOT NULL,
 noFournisseur      INTEGER                 NOT NULL,
 numeroCivique      INTEGER                 NOT NULL,
 rue                VARCHAR(20)             NOT NULL,
 ville              VARCHAR(20)             NOT NULL,
 pays               VARCHAR(20)             NOT NULL,
 codePostal         VARCHAR(10)             NOT NULL,
 PRIMARY KEY (noClient, noFournisseur)
)
/
CREATE TABLE Fournisseur
(noFournisseur		INTEGER		NOT NULL,
 motDePasse    		VARCHAR(20)	NOT NULL,
 raisonSociale		VARCHAR(50)	NOT NULL,
 telephone		VARCHAR(10)	NOT NULL,
 PRIMARY KEY 	(noFournisseur)
)
/
CREATE TABLE Produit
(noProduit          INTEGER     NOT NULL,
 description        VARCHAR(30) NOT NULL,
 quantite           INTEGER     NOT NULL,
 quantiteMinimum    INTEGER     NOT NULL,
 PRIMARY KEY (noProduit)
)
/
CREATE TABLE Priorite
(noFournisseur  INTEGER         NOT NULL,
 noProduit      INTEGER         NOT NULL,
 priorite       INTEGER         NOT NULL,
 PRIMARY KEY (noFournisseur, noProduit),
 FOREIGN KEY (noFournisseur)             REFERENCES Fournisseur(noFournisseur),
 FOREIGN KEY (noProduit)                 REFERENCES Produit(noProduit)
)
/
CREATE TABLE Catalogue
(noProduit      INTEGER     NOT NULL,
 dateCatalogue  DATE        NOT NULL,
 prix           FLOAT       NOT NULL,
 PRIMARY KEY (noProduit, dateCatalogue),
 FOREIGN KEY (noProduit)                 REFERENCES Produit(noProduit)
)
/
CREATE TABLE Commande
(noCommande     INTEGER     NOT NULL,
 dateCommande   DATE        NOT NULL,
 annulee        INTEGER     NOT NULL
        CHECK (annulee IN(0, 1)),
 noClient       INTEGER     NOT NULL,
 PRIMARY KEY (noCommande),
 FOREIGN KEY (noClient) REFERENCES Client(noClient)
)
/
CREATE TABLE Item 
(codeZebre      INTEGER     NOT NULL,
 noProduit      INTEGER     NOT NULL,
 PRIMARY KEY (codeZebre),
 FOREIGN KEY (noProduit) REFERENCES Produit(noProduit)
)
/
CREATE TABLE LigneCommande 
(noCommande    		INTEGER     NOT NULL,
 noProduit     		INTEGER     NOT NULL,
 quantite      		INTEGER     NOT NULL
        CHECK (quantite > 0),
 quantiteRestante   	INTEGER     NOT NULL
	CHECK (quantiteRestante >= 0),
 PRIMARY KEY 		(noProduit, noCommande),
 FOREIGN KEY 		(noProduit)              REFERENCES Produit(noProduit),
 FOREIGN KEY 		(noCommande)             REFERENCES Commande(noCommande)
)
/
CREATE TABLE FactureLivraison 
(noLivraison        INTEGER NOT NULL,
 dateLivraison      DATE    NOT NULL,
 dateLimitePaiement DATE    NOT NULL,
 sousTotal          FLOAT   NOT NULL,
 payee              INTEGER NOT NULL
        CHECK (payee IN(0 ,1)),
 soldeRestant       FLOAT   NOT NULL,
 PRIMARY KEY	(noLivraison)
)
/
CREATE TABLE LigneLivraison 
(noProduit      INTEGER             NOT NULL,
 noCommande     INTEGER             NOT NULL,
 noLivraison    INTEGER             NOT NULL,
 codeZebre      INTEGER             NOT NULL
        CHECK (codeZebre >= 0),
 PRIMARY KEY (codeZebre),
 FOREIGN KEY (noProduit, noCommande)                 		REFERENCES LigneCommande(noProduit, noCommande),
 FOREIGN KEY (noLivraison)                           		REFERENCES FactureLivraison(noLivraison),
 FOREIGN KEY (codeZebre)                             		REFERENCES Item(codeZebre)
)
/
CREATE TABLE PaiementCheque 
(noCheque       VARCHAR(20)         NOT NULL,
 banque         VARCHAR(20)         NOT NULL,
 datePaiement   DATE                NOT NULL,
 montant        FLOAT               NOT NULL,
 noLivraison    INTEGER             NOT NULL,
 PRIMARY KEY (noCheque),
 FOREIGN KEY (noLivraison) REFERENCES FactureLivraison(noLivraison)
)
/
CREATE TABLE PaiementCarteCredit 
(noCarte       VARCHAR (20)        NOT NULL,
 typeDeCarte   VARCHAR (20)        NOT NULL
        CHECK (typeDeCarte IN ('VISA', 'Master Card', 'American Express')),
 datePaiement  DATE                NOT NULL,
 montant       FLOAT               NOT NULL,
 noLivraison   INTEGER             NOT NULL,
 PRIMARY KEY (noCarte),
 FOREIGN KEY (noLivraison) REFERENCES FactureLivraison(noLivraison)
)
/



------------------------------
------------------------------
-- Incrementation automatique
------------------------------
------------------------------
CREATE SEQUENCE sequence_client
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_client
BEFORE INSERT
ON Client
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_client.nextval INTO :NEW.noClient FROM dual;
END;
/



CREATE SEQUENCE sequence_fournisseur
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_fournisseur
BEFORE INSERT
ON Fournisseur
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_fournisseur.nextval INTO :NEW.noFournisseur FROM dual;
END;
/



CREATE SEQUENCE sequence_commande
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_sequence_commande
BEFORE INSERT
ON Commande
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_commande.nextval INTO :NEW.noCommande FROM dual;
END;
/


CREATE SEQUENCE sequence_FactureLivraison
START WITH 1
INCREMENT BY 1
/

CREATE OR REPLACE TRIGGER trigger_seq_FactureLivraison
BEFORE INSERT
ON FactureLivraison
REFERENCING NEW AS NEW
FOR EACH ROW
BEGIN
SELECT sequence_FactureLivraison.nextval INTO :NEW.noLivraison FROM dual;
END;
/



----------
-- TRIGGER
----------
------
-- 1
------
CREATE OR REPLACE TRIGGER ReduireQuantite
AFTER INSERT ON LigneCommande
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	Produit
	SET 	quantite = (quantite - :ligneApres.quantite)
	WHERE 	noProduit = :ligneApres.noProduit;
END;
/



------
-- 2
------
CREATE OR REPLACE TRIGGER BloquerQteLivreeQteEnStock
BEFORE INSERT ON LigneCommande
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	qtite INTEGER;
BEGIN    
        SELECT	quantite INTO qtite
        FROM	Produit
        WHERE	Produit.noProduit = :ligneApres.noProduit;

	IF (:ligneApres.quantite > qtite) THEN 
		raise_application_error (-20100, 'La quantite a livrer est superieure a la quantite en stock!');
	END IF;
END;
/



------
-- 3
------
--CREATE OR REPLACE TRIGGER BloquerQteLivreeQteCommande
--BEFORE INSERT ON LigneLivraison
--REFERENCING
--	NEW AS ligneApres
--FOR EACH ROW
--DECLARE
--	qteLivraison	INTEGER;
--	qteReste	INTEGER;
--BEGIN    
--        SELECT	COUNT(*) INTO qteLivraison
--        FROM	LigneLivraison
--	WHERE	:ligneApres.noProduit = LigneCommande.noProduit;
--		:ligneApres.noCommande = LigneCommande.noCommande;
--
--	SELECT	quantiteRestante INTO qteReste
--	FROM	LigneCommande
--	WHERE	:ligneApres.noProduit = LigneCommande.noProduit AND
--		:ligneApres.noCommande = LigneCommande.noCommande;
--
--	IF (qteLivraison > qteReste) THEN 
--		raise_application_error (-20100, 'La quantite a livrer est superieure a la quantite restante de la commande');
--	END IF;
--END;
--/



------
-- 4
------
CREATE OR REPLACE TRIGGER BloquerCarteCredit
BEFORE INSERT ON PaiementCarteCredit
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	restant	INTEGER;
BEGIN
	SELECT	soldeRestant INTO restant
	FROM	FactureLivraison
	WHERE	:ligneApres.noLivraison = FactureLivraison.noLivraison;

	IF (:ligneApres.montant > restant) THEN
		raise_application_error(-20100, 'Le paiement par carte de credit depasse le montant restant a payer!');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER BloquerCheque
BEFORE INSERT ON PaiementCheque
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
DECLARE
	restant	INTEGER;
BEGIN
	SELECT	soldeRestant INTO restant
	FROM	FactureLivraison
	WHERE	:ligneApres.noLivraison = FactureLivraison.noLivraison;

	IF (:ligneApres.montant > restant) THEN
		raise_application_error(-20100, 'Le paiement par cheque depasse le montant restant a payer!');
	END IF;
END;
/



---------------------
-- 5 Donnees derivees
---------------------
-- 
--CREATE OR REPLACE TRIGGER PaiementAutoriseCarteCredit
--AFTER INSERT ON PaiementCarteCredit
--REFERENCING
--NEW AS ligne
--FOR EACH ROW
--	UPDATE 	FactureLivraison
--	SET 	soldeRestant = (soldeRestant - :ligne.montant)
--	WHERE 	noLivraison = :ligne.noLivraison;
--END;
--/
--
--CREATE OR REPLACE TRIGGER PaiementAutoriseCheque
--AFTER INSERT ON PaiementCheque
--REFERENCING
--	NEW AS ligneApres;
--FOR EACH ROW
--	UPDATE 	FactureLivraison
--	SET 	soldeRestant = (soldeRestant - :ligneApres.montant)
--	WHERE 	noLivraison = :ligneApres.noLivraison;
--END;
--/



CREATE OR REPLACE TRIGGER PaiementAutoriseCarteCredit
AFTER INSERT ON PaiementCarteCredit
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	FactureLivraison
	SET 	soldeRestant = (soldeRestant - :ligneApres.montant)
	WHERE 	FactureLivraison.noLivraison = :ligneApres.noLivraison;
END;
/



CREATE OR REPLACE TRIGGER PaiementAutoriseCheque
AFTER INSERT ON PaiementCheque
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	UPDATE 	FactureLivraison
	SET 	soldeRestant = (soldeRestant - :ligneApres.montant)
	WHERE 	FactureLivraison.noLivraison = :ligneApres.noLivraison;
END;
/



CREATE OR REPLACE TRIGGER ChangerPourFacturePayee
BEFORE UPDATE ON FactureLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	IF (:ligneApres.soldeRestant = 0) THEN
		:ligneApres.payee := 1;
	END IF;
END;
/

------------ not working ---------
--CREATE OR REPLACE TRIGGER TestDeCave
--AFTER UPDATE ON FactureLivraison
--REFERENCING
----	OLD AS old
--	NEW AS new
--FOR EACH ROW
--BEGIN
--	IF (:new.payee = 1) THEN
--		UPDATE	FactureLivraison
--		SET	sousTotal = 666
--		WHERE	noLivraison = :new.noLivraison;
--	END IF;
----	IF (:old.payee = 1) THEN
----		raise_application_error(-20100, 'old');
----	END IF;
----	IF (:new.payee = 1) THEN
----		raise_application_error(-20100, 'new');
----		:new.sousTotal := 666;
----	END IF;
--END;
/

CREATE OR REPLACE TRIGGER EnleverItem
AFTER INSERT ON LigneLivraison
REFERENCING
	NEW AS ligneApres
FOR EACH ROW
BEGIN
	DELETE	FROM Item
	WHERE	codeZebre = :ligneApres.codeZebre;
END;
/
