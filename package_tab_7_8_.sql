CREATE OR REPLACE PACKAGE tab_7_tab_8 IS

    PROCEDURE prc_inserir(
        p_id_viagem     IN  passagem.id_viagem%TYPE,
        p_id_passageiro IN  passagem.id_passageiro%TYPE,
        p_assento       IN  passagem.assento%TYPE,
        p_valor         IN  passagem.valor%TYPE,
        p_status        IN  passagem.status%TYPE DEFAULT 'ATIVA'
    );


    FUNCTION fnc_buscar(p_id_passagem IN passagem.id_passagem%TYPE)
        RETURN SYS_REFCURSOR;

    
    FUNCTION fnc_listar
        RETURN SYS_REFCURSOR;


    PROCEDURE prc_atualizar(
        p_id_passagem   IN  passagem.id_passagem%TYPE,
        p_assento       IN  passagem.assento%TYPE DEFAULT NULL,
        p_valor         IN  passagem.valor%TYPE DEFAULT NULL,
        p_status        IN  passagem.status%TYPE DEFAULT NULL
    );

    PROCEDURE prc_excluir(p_id_passagem IN passagem.id_passagem%TYPE);

     PROCEDURE prc_inserir(
        p_id_veiculo   IN  manutencao.id_veiculo%TYPE,
        p_tipo         IN  manutencao.tipo%TYPE,
        p_descricao    IN  manutencao.descricao%TYPE DEFAULT NULL,
        p_data_entrada IN  manutencao.data_entrada%TYPE,
        p_data_saida   IN  manutencao.data_saida%TYPE DEFAULT NULL,
        p_custo        IN  manutencao.custo%TYPE DEFAULT NULL,
        p_oficina      IN  manutencao.oficina%TYPE DEFAULT NULL
    );

   
    FUNCTION fnc_buscar(p_id_manutencao IN manutencao.id_manutencao%TYPE)
        RETURN SYS_REFCURSOR;

    FUNCTION fnc_listar
        RETURN SYS_REFCURSOR;


    PROCEDURE prc_atualizar(
        p_id_manutencao IN  manutencao.id_manutencao%TYPE,
        p_tipo          IN  manutencao.tipo%TYPE DEFAULT NULL,
        p_descricao     IN  manutencao.descricao%TYPE DEFAULT NULL,
        p_data_saida    IN  manutencao.data_saida%TYPE DEFAULT NULL,
        p_custo         IN  manutencao.custo%TYPE DEFAULT NULL,
        p_oficina       IN  manutencao.oficina%TYPE DEFAULT NULL
    );


    PROCEDURE prc_excluir(p_id_manutencao IN manutencao.id_manutencao%TYPE);


END tab_7_tab_8;
/


CREATE OR REPLACE PACKAGE BODY tab_7_tab_8 IS


    PROCEDURE prc_inserir(
        p_id_viagem     IN  passagem.id_viagem%TYPE,
        p_id_passageiro IN  passagem.id_passageiro%TYPE,
        p_assento       IN  passagem.assento%TYPE,
        p_valor         IN  passagem.valor%TYPE,
        p_status        IN  passagem.status%TYPE DEFAULT 'ATIVA'
    ) IS
    BEGIN
        INSERT INTO passagem (id_viagem, id_passageiro, assento, valor, status)
        VALUES (p_id_viagem, p_id_passageiro, p_assento, p_valor, p_status);
        COMMIT;
    END prc_inserir;

    FUNCTION fnc_buscar(p_id_passagem IN passagem.id_passagem%TYPE)
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT id_passagem, id_viagem, id_passageiro,
                   assento, valor, data_compra, status
            FROM passagem
            WHERE id_passagem = p_id_passagem;
        RETURN v_cursor;
    END fnc_buscar;


    FUNCTION fnc_listar
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT id_passagem, id_viagem, id_passageiro,
                   assento, valor, data_compra, status
            FROM passagem
            ORDER BY data_compra DESC;
        RETURN v_cursor;
    END fnc_listar;

 
    PROCEDURE prc_atualizar(
        p_id_passagem   IN  passagem.id_passagem%TYPE,
        p_assento       IN  passagem.assento%TYPE DEFAULT NULL,
        p_valor         IN  passagem.valor%TYPE DEFAULT NULL,
        p_status        IN  passagem.status%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE passagem SET
            assento = NVL(p_assento, assento),
            valor   = NVL(p_valor, valor),
            status  = NVL(p_status, status)
        WHERE id_passagem = p_id_passagem;
        COMMIT;
    END prc_atualizar;


    PROCEDURE prc_excluir(p_id_passagem IN passagem.id_passagem%TYPE) IS
    BEGIN
        DELETE FROM passagem WHERE id_passagem = p_id_passagem;
        COMMIT;
    END prc_excluir;


    PROCEDURE prc_inserir(
        p_id_veiculo   IN  manutencao.id_veiculo%TYPE,
        p_tipo         IN  manutencao.tipo%TYPE,
        p_descricao    IN  manutencao.descricao%TYPE DEFAULT NULL,
        p_data_entrada IN  manutencao.data_entrada%TYPE,
        p_data_saida   IN  manutencao.data_saida%TYPE DEFAULT NULL,
        p_custo        IN  manutencao.custo%TYPE DEFAULT NULL,
        p_oficina      IN  manutencao.oficina%TYPE DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO manutencao (id_veiculo, tipo, descricao, data_entrada, data_saida, custo, oficina)
        VALUES (p_id_veiculo, p_tipo, p_descricao, p_data_entrada, p_data_saida, p_custo, p_oficina);
        COMMIT;
    END prc_inserir;


    FUNCTION fnc_buscar(p_id_manutencao IN manutencao.id_manutencao%TYPE)
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT id_manutencao, id_veiculo, tipo, descricao,
                   data_entrada, data_saida, custo, oficina
            FROM manutencao
            WHERE id_manutencao = p_id_manutencao;
        RETURN v_cursor;
    END fnc_buscar;


    FUNCTION fnc_listar
        RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT id_manutencao, id_veiculo, tipo, descricao,
                   data_entrada, data_saida, custo, oficina
            FROM manutencao
            ORDER BY data_entrada DESC;
        RETURN v_cursor;
    END fnc_listar;

  
    PROCEDURE prc_atualizar(
        p_id_manutencao IN  manutencao.id_manutencao%TYPE,
        p_tipo          IN  manutencao.tipo%TYPE DEFAULT NULL,
        p_descricao     IN  manutencao.descricao%TYPE DEFAULT NULL,
        p_data_saida    IN  manutencao.data_saida%TYPE DEFAULT NULL,
        p_custo         IN  manutencao.custo%TYPE DEFAULT NULL,
        p_oficina       IN  manutencao.oficina%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE manutencao SET
            tipo        = NVL(p_tipo, tipo),
            descricao   = NVL(p_descricao, descricao),
            data_saida  = NVL(p_data_saida, data_saida),
            custo       = NVL(p_custo, custo),
            oficina     = NVL(p_oficina, oficina)
        WHERE id_manutencao = p_id_manutencao;
        COMMIT;
    END prc_atualizar;

    PROCEDURE prc_excluir(p_id_manutencao IN manutencao.id_manutencao%TYPE) IS
    BEGIN
        DELETE FROM manutencao WHERE id_manutencao = p_id_manutencao;
        COMMIT;
    END prc_excluir;


END tab_7_tab_8;
/
