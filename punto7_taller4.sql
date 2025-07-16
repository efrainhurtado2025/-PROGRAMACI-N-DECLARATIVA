-- 1. Crear las tablas originales
CREATE TABLE Continente (
    Id SERIAL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL
);

CREATE TABLE TipoRegion (
    Id SERIAL PRIMARY KEY,
    Tipo VARCHAR(100) NOT NULL
);

CREATE TABLE Moneda (
    Id SERIAL PRIMARY KEY,
    Moneda VARCHAR(100) NOT NULL,
    Sigla VARCHAR(10),
    Imagen BYTEA
);

CREATE TABLE Pais (
    Id SERIAL PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    IdContinente INTEGER NOT NULL REFERENCES Continente(Id),
    IdTipoRegion INTEGER NOT NULL REFERENCES TipoRegion(Id),
    IdMoneda INTEGER NOT NULL REFERENCES Moneda(Id),
    Mapa BYTEA,
    Bandera BYTEA
);

-- 2. Insertar datos de prueba
INSERT INTO Continente (Nombre) VALUES ('América'), ('Europa');
INSERT INTO TipoRegion (Tipo) VALUES ('Departamento'), ('Provincia');
INSERT INTO Moneda (Moneda, Sigla) VALUES 
    ('Peso colombiano', 'COP'),
    ('Euro', 'EUR');
INSERT INTO Pais (Nombre, IdContinente, IdTipoRegion, IdMoneda) 
VALUES 
    ('Colombia', 1, 1, 1),
    ('España', 2, 2, 2);

-- 3. Desnormalización: agregar los campos de moneda directamente a Pais
ALTER TABLE Pais
ADD COLUMN MonedaNombre VARCHAR(100),
ADD COLUMN Sigla VARCHAR(10),
ADD COLUMN ImagenMoneda BYTEA;

-- 4. Copiar los datos de Moneda a los nuevos campos de Pais
UPDATE Pais
SET 
    MonedaNombre = M.Moneda,
    Sigla = M.Sigla,
    ImagenMoneda = M.Imagen
FROM Moneda M
WHERE Pais.IdMoneda = M.Id;

-- 5. Eliminar la clave foránea y la columna IdMoneda
ALTER TABLE Pais DROP CONSTRAINT IF EXISTS pais_idmoneda_fkey;
ALTER TABLE Pais DROP COLUMN IdMoneda;

-- 6. Verificación: consulta final para ver los cambios
SELECT 
    P.Nombre AS Pais,
    C.Nombre AS Continente,
    T.Tipo AS TipoRegion,
    P.MonedaNombre,
    P.Sigla,
    P.Mapa,
    P.Bandera
FROM Pais P
JOIN Continente C ON P.IdContinente = C.Id
JOIN TipoRegion T ON P.IdTipoRegion = T.Id;