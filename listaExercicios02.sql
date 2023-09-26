DELIMITER //

CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END//

DELIMITER ;
CALL sp_ListarAutores();

--2
DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo, Autor.Nome AS NomeAutor, Autor.Sobrenome AS SobrenomeAutor
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID
    WHERE Categoria.Nome = categoriaNome;
END//

DELIMITER ;
CALL sp_LivrosPorCategoria('Romance');
CALL sp_LivrosPorCategoria('Ciência');
CALL sp_LivrosPorCategoria('Ficção Científica');

--3
DELIMITER //
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoriaNome VARCHAR(100), OUT totalLivros INT)
BEGIN
    SELECT COUNT(*) INTO totalLivros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END//
DELIMITER ;

DECLARE @total INT;
CALL sp_ContarLivrosPorCategoria('Romance', @total);
SELECT @total AS TotalLivros;

--4
DELIMITER //
CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoriaNome VARCHAR(100), OUT possuiLivros BOOL)
BEGIN
    DECLARE totalLivros INT;

    SELECT COUNT(*) INTO totalLivros
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;

    IF totalLivros > 0 THEN
        SET possuiLivros = TRUE;
    ELSE
        SET possuiLivros = FALSE;
    END IF;
END//

DELIMITER ;
