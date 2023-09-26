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
DECLARE @possuiLivros BOOL;
CALL sp_VerificarLivrosCategoria('Romance', @possuiLivros);
IF @possuiLivros THEN
    SELECT 'A categoria possui livros.' AS Resultado;
ELSE
    SELECT 'A categoria não possui livros.' AS Resultado;
END IF;

--5
DELIMITER //
CREATE PROCEDURE sp_LivrosAteAno(IN anoPublicacao INT)
BEGIN
    SELECT Livro.Titulo, Autor.Nome AS NomeAutor, Autor.Sobrenome AS SobrenomeAutor
    FROM Livro
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID
    WHERE Livro.Ano_Publicacao <= anoPublicacao;
END//

DELIMITER ;
CALL sp_LivrosAteAno(2010);
CALL sp_LivrosAteAno(2005);


--6
DELIMITER //
CREATE PROCEDURE sp_TitulosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END//

DELIMITER ;
CALL sp_TitulosPorCategoria('Romance');
CALL sp_TitulosPorCategoria('Ciência');
CALL sp_TitulosPorCategoria('Ficção Científica');

--7
DELIMITER //
CREATE PROCEDURE sp_AdicionarLivro(
    IN tituloLivro VARCHAR(255),
    IN editoraID INT,
    IN anoPublicacao INT,
    IN numeroPaginas INT,
    IN categoriaID INT,
    OUT resultado VARCHAR(255)
)
BEGIN
    DECLARE livroExiste INT;
    
    -- Verificar se o livro já existe com o mesmo título
    SELECT COUNT(*) INTO livroExiste
    FROM Livro
    WHERE Titulo = tituloLivro;
    
    -- Se o livro já existe, retornar uma mensagem de erro
    IF livroExiste > 0 THEN
        SET resultado = 'Erro: Já existe um livro com esse título.';
    ELSE
        -- Inserir o novo livro na tabela Livro
        INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
        VALUES (tituloLivro, editoraID, anoPublicacao, numeroPaginas, categoriaID);
        
        SET resultado = 'Livro adicionado com sucesso.';
    END IF;
END//

DELIMITER ;
DECLARE @resultado VARCHAR(255);
CALL sp_AdicionarLivro('Novo Livro', 1, 2023, 300, 2, @resultado);
SELECT @resultado AS Resultado;
