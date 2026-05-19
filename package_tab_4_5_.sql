
CREATE OR REPLACE PACKAGE tab_4_tab_5 IS


    PROCEDURE prc_inserir(
        p_id_empresa      IN rota.id_empresa%TYPE,
        p_descricao       IN rota.descricao%TYPE,
        p_origem          IN rota.origem%TYPE,
        p_destino         IN rota.destino%TYPE,
        p_distancia_km    IN rota.distancia_km%TYPE,
        p_duracao_minutos IN rota.duracao_minutos%TYPE,
        p_ativa           IN rota.ativa%TYPE DEFAULT 'S'
    );

    FUNCTION fnc_buscar(p_id_rota IN rota.id_rota%TYPE) 
        RETURN SYS_REFCURSOR;


    FUNCTION fnc_listar 
        RETURN SYS_REFCURSOR;


    PROCEDURE prc_atualizar(
        p_id_rota         IN rota.id_rota%TYPE,
        p_descricao       IN rota.descricao%TYPE DEFAULT NULL,
        p_distancia_km    IN rota.distancia_km%TYPE DEFAULT NULL,
        p_duracao_minutos IN rota.duracao_minutos%TYPE DEFAULT NULL,
        p_ativa           IN rota.ativa%TYPE DEFAULT NULL
    );

    PROCEDURE prc_excluir(p_id_rota IN rota.id_rota%TYPE);

      PROCEDURE prc_inserir(
        p_id_rota      IN viagem.id_rota%TYPE,
        p_id_motorista IN viagem.id_motorista%TYPE,
        p_id_veiculo   IN viagem.id_veiculo%TYPE,
        p_data_saida   IN viagem.data_saida%TYPE,
        p_status       IN viagem.status%TYPE DEFAULT 'AGENDADA',
        p_observacao   IN viagem.observacao%TYPE DEFAULT NULL
    );

  
    FUNCTION fnc_buscar(p_id_viagem IN viagem.id_viagem%TYPE) 
        RETURN SYS_REFCURSOR;


    FUNCTION fnc_listar 
        RETURN SYS_REFCURSOR;

  
    PROCEDURE prc_atualizar(
        p_id_viagem     IN viagem.id_viagem%TYPE,
        p_data_chegada  IN viagem.data_chegada%TYPE DEFAULT NULL,
        p_status        IN viagem.status%TYPE DEFAULT NULL,
        p_observacao    IN viagem.observacao%TYPE DEFAULT NULL
    );


    PROCEDURE prc_excluir(p_id_viagem IN viagem.id_viagem%TYPE);


END tab_4_tab_5;
/

CREATE OR REPLACE PACKAGE BODY tab_4_tab_5 IS

    PROCEDURE prc_inserir(
        p_id_empresa      IN rota.id_empresa%TYPE,
        p_descricao       IN rota.descricao%TYPE,
        p_origem          IN rota.origem%TYPE,
        p_destino         IN rota.destino%TYPE,
        p_distancia_km    IN rota.distancia_km%TYPE,
        p_duracao_minutos IN rota.duracao_minutos%TYPE,
        p_ativa           IN rota.ativa%TYPE DEFAULT 'S'
    ) IS
    BEGIN
        INSERT INTO rota (id_empresa, descricao, origem, destino, distancia_km, duracao_minutos, ativa)
        VALUES (p_id_empresa, p_descricao, p_origem, p_destino, p_distancia_km, p_duracao_minutos, p_ativa);
        COMMIT;
    END prc_inserir;

    FUNCTION fnc_buscar(p_id_rota IN rota.id_rota%TYPE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM rota WHERE id_rota = p_id_rota;
        RETURN v_cursor;
    END fnc_buscar;

    FUNCTION fnc_listar RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM rota ORDER BY descricao ASC;
        RETURN v_cursor;
    END fnc_listar;

    PROCEDURE prc_atualizar(
        p_id_rota         IN rota.id_rota%TYPE,
        p_descricao       IN rota.descricao%TYPE DEFAULT NULL,
        p_distancia_km    IN rota.distancia_km%TYPE DEFAULT NULL,
        p_duracao_minutos IN rota.duracao_minutos%TYPE DEFAULT NULL,
        p_ativa           IN rota.ativa%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE rota SET
            descricao       = NVL(p_descricao, descricao),
            distancia_km    = NVL(p_distancia_km, distancia_km),
            duracao_minutos = NVL(p_duracao_minutos, duracao_minutos),
            ativa           = NVL(p_ativa, ativa)
        WHERE id_rota = p_id_rota;
        COMMIT;
    END prc_atualizar;

    PROCEDURE prc_excluir(p_id_rota IN rota.id_rota%TYPE) IS
    BEGIN
        DELETE FROM rota WHERE id_rota = p_id_rota;
        COMMIT;
    END prc_excluir;

    PROCEDURE prc_inserir(
        p_id_rota      IN viagem.id_rota%TYPE,
        p_id_motorista IN viagem.id_motorista%TYPE,
        p_id_veiculo   IN viagem.id_veiculo%TYPE,
        p_data_saida   IN viagem.data_saida%TYPE,
        p_status       IN viagem.status%TYPE DEFAULT 'AGENDADA',
        p_observacao   IN viagem.observacao%TYPE DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO viagem (id_rota, id_motorista, id_veiculo, data_saida, status, observacao)
        VALUES (p_id_rota, p_id_motorista, p_id_veiculo, p_data_saida, p_status, p_observacao);
        COMMIT;
    END prc_inserir;

    FUNCTION fnc_buscar(p_id_viagem IN viagem.id_viagem%TYPE) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM viagem WHERE id_viagem = p_id_viagem;
        RETURN v_cursor;
    END fnc_buscar;

    FUNCTION fnc_listar RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM viagem ORDER BY data_saida DESC;
        RETURN v_cursor;
    END fnc_listar;

    PROCEDURE prc_atualizar(
        p_id_viagem     IN viagem.id_viagem%TYPE,
        p_data_chegada  IN viagem.data_chegada%TYPE DEFAULT NULL,
        p_status        IN viagem.status%TYPE DEFAULT NULL,
        p_observacao    IN viagem.observacao%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE viagem SET
            data_chegada = NVL(p_data_chegada, data_chegada),
            status       = NVL(p_status, status),
            observacao   = NVL(p_observacao, observacao)
        WHERE id_viagem = p_id_viagem;
        COMMIT;
    END prc_atualizar;

    PROCEDURE prc_excluir(p_id_viagem IN viagem.id_viagem%TYPE) IS
    BEGIN
        DELETE FROM viagem WHERE id_viagem = p_id_viagem;
        COMMIT;
    END prc_excluir;

END tab_4_tab_5;
/