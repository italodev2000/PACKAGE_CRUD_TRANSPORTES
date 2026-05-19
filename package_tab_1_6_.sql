CREATE OR REPLACE PACKAGE tab_1_tab_6 AS
    PROCEDURE INSERIR_EMPRESA (
        p_nome          IN  VARCHAR2,
        p_cnpj          IN  VARCHAR2,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_fundacao IN  DATE DEFAULT NULL,
        p_id_empresa    OUT NUMBER
    );
    FUNCTION BUSCAR_EMPRESA_POR_ID (
        p_id_empresa IN NUMBER
    ) RETURN EMPRESA%ROWTYPE;
    PROCEDURE LISTAR_EMPRESAS (
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE ATUALIZAR_EMPRESA (
        p_id_empresa    IN  NUMBER,
        p_nome          IN  VARCHAR2 DEFAULT NULL,
        p_cnpj          IN  VARCHAR2 DEFAULT NULL,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_fundacao IN  DATE DEFAULT NULL
    );
    PROCEDURE REMOVER_EMPRESA (
        p_id_empresa IN NUMBER
    );
    PROCEDURE INSERIR_PASSAGEIRO (
        p_nome          IN  VARCHAR2,
        p_cpf           IN  VARCHAR2,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_nasc     IN  DATE DEFAULT NULL,
        p_id_passageiro OUT NUMBER
    );
    FUNCTION BUSCAR_PASSAGEIRO_POR_ID (
        p_id_passageiro IN NUMBER
    ) RETURN PASSAGEIRO%ROWTYPE;
    PROCEDURE LISTAR_PASSAGEIROS (
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE ATUALIZAR_PASSAGEIRO (
        p_id_passageiro IN  NUMBER,
        p_nome          IN  VARCHAR2 DEFAULT NULL,
        p_cpf           IN  VARCHAR2 DEFAULT NULL,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_nasc     IN  DATE DEFAULT NULL
    );
    PROCEDURE REMOVER_PASSAGEIRO (
        p_id_passageiro IN NUMBER
    );
    PROCEDURE INSERIR_ROTA (
        p_id_empresa      IN  NUMBER,
        p_descricao       IN  VARCHAR2,
        p_origem          IN  VARCHAR2,
        p_destino         IN  VARCHAR2,
        p_distancia_km    IN  NUMBER DEFAULT NULL,
        p_duracao_minutos IN  NUMBER DEFAULT NULL,
        p_ativa           IN  CHAR DEFAULT 'S',
        p_id_rota         OUT NUMBER
    );
    FUNCTION BUSCAR_ROTA_POR_ID (
        p_id_rota IN NUMBER
    ) RETURN ROTA%ROWTYPE;
    PROCEDURE LISTAR_ROTAS (
        p_cursor OUT SYS_REFCURSOR
    );
    PROCEDURE ATUALIZAR_ROTA (
        p_id_rota         IN  NUMBER,
        p_id_empresa      IN  NUMBER DEFAULT NULL,
        p_descricao       IN  VARCHAR2 DEFAULT NULL,
        p_origem          IN  VARCHAR2 DEFAULT NULL,
        p_destino         IN  VARCHAR2 DEFAULT NULL,
        p_distancia_km    IN  NUMBER DEFAULT NULL,
        p_duracao_minutos IN  NUMBER DEFAULT NULL,
        p_ativa           IN  CHAR DEFAULT NULL
    );
    PROCEDURE REMOVER_ROTA (
        p_id_rota IN NUMBER
    );
END tab_1_tab_6;
/

CREATE OR REPLACE PACKAGE BODY tab_1_tab_6 AS
    PROCEDURE INSERIR_EMPRESA (
        p_nome          IN  VARCHAR2,
        p_cnpj          IN  VARCHAR2,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_fundacao IN  DATE DEFAULT NULL,
        p_id_empresa    OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO empresa (nome, cnpj, telefone, email, data_fundacao)
        VALUES (p_nome, p_cnpj, p_telefone, p_email, p_data_fundacao)
        RETURNING id_empresa INTO p_id_empresa;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro: CNPJ ' || p_cnpj || ' já existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Erro ao inserir empresa: ' || SQLERRM);
    END INSERIR_EMPRESA;

    FUNCTION BUSCAR_EMPRESA_POR_ID (
        p_id_empresa IN NUMBER
    ) RETURN EMPRESA%ROWTYPE IS
        v_empresa EMPRESA%ROWTYPE;
    BEGIN
        SELECT * INTO v_empresa FROM empresa WHERE id_empresa = p_id_empresa;
        RETURN v_empresa;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20003, 'Empresa com ID ' || p_id_empresa || ' não encontrada.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20004, 'Erro ao buscar empresa: ' || SQLERRM);
    END BUSCAR_EMPRESA_POR_ID;

    PROCEDURE LISTAR_EMPRESAS (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_empresa, nome, cnpj, telefone, email, data_fundacao
            FROM empresa;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20005, 'Erro ao listar empresas: ' || SQLERRM);
    END LISTAR_EMPRESAS;

    PROCEDURE ATUALIZAR_EMPRESA (
        p_id_empresa    IN  NUMBER,
        p_nome          IN  VARCHAR2 DEFAULT NULL,
        p_cnpj          IN  VARCHAR2 DEFAULT NULL,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_fundacao IN  DATE DEFAULT NULL
    ) IS
        v_count NUMBER;
    BEGIN
        UPDATE empresa
        SET
            nome          = NVL(p_nome, nome),
            cnpj          = NVL(p_cnpj, cnpj),
            telefone      = NVL(p_telefone, telefone),
            email         = NVL(p_email, email),
            data_fundacao = NVL(p_data_fundacao, data_fundacao)
        WHERE
            id_empresa = p_id_empresa;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Empresa com ID ' || p_id_empresa || ' não encontrada para atualização.');
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20007, 'Erro: CNPJ ' || p_cnpj || ' já existe para outra empresa.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20008, 'Erro ao atualizar empresa: ' || SQLERRM);
    END ATUALIZAR_EMPRESA;

    PROCEDURE REMOVER_EMPRESA (
        p_id_empresa IN NUMBER
    ) IS
        v_count NUMBER;
    BEGIN
        DELETE FROM empresa WHERE id_empresa = p_id_empresa;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20009, 'Empresa com ID ' || p_id_empresa || ' não encontrada para remoção.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20010, 'Erro ao remover empresa: ' || SQLERRM);
    END REMOVER_EMPRESA;

    PROCEDURE INSERIR_PASSAGEIRO (
        p_nome          IN  VARCHAR2,
        p_cpf           IN  VARCHAR2,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_nasc     IN  DATE DEFAULT NULL,
        p_id_passageiro OUT NUMBER
    ) IS
    BEGIN
        INSERT INTO passageiro (nome, cpf, telefone, email, data_nasc)
        VALUES (p_nome, p_cpf, p_telefone, p_email, p_data_nasc)
        RETURNING id_passageiro INTO p_id_passageiro;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20011, 'Erro: CPF ' || p_cpf || ' já existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20012, 'Erro ao inserir passageiro: ' || SQLERRM);
    END INSERIR_PASSAGEIRO;

    FUNCTION BUSCAR_PASSAGEIRO_POR_ID (
        p_id_passageiro IN NUMBER
    ) RETURN PASSAGEIRO%ROWTYPE IS
        v_passageiro PASSAGEIRO%ROWTYPE;
    BEGIN
        SELECT * INTO v_passageiro FROM passageiro WHERE id_passageiro = p_id_passageiro;
        RETURN v_passageiro;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20013, 'Passageiro com ID ' || p_id_passageiro || ' não encontrado.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20014, 'Erro ao buscar passageiro: ' || SQLERRM);
    END BUSCAR_PASSAGEIRO_POR_ID;

    PROCEDURE LISTAR_PASSAGEIROS (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_passageiro, nome, cpf, telefone, email, data_nasc
            FROM passageiro;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20015, 'Erro ao listar passageiros: ' || SQLERRM);
    END LISTAR_PASSAGEIROS;

    PROCEDURE ATUALIZAR_PASSAGEIRO (
        p_id_passageiro IN  NUMBER,
        p_nome          IN  VARCHAR2 DEFAULT NULL,
        p_cpf           IN  VARCHAR2 DEFAULT NULL,
        p_telefone      IN  VARCHAR2 DEFAULT NULL,
        p_email         IN  VARCHAR2 DEFAULT NULL,
        p_data_nasc     IN  DATE DEFAULT NULL
    ) IS
        v_count NUMBER;
    BEGIN
        UPDATE passageiro
        SET
            nome          = NVL(p_nome, nome),
            cpf           = NVL(p_cpf, cpf),
            telefone      = NVL(p_telefone, telefone),
            email         = NVL(p_email, email),
            data_nasc     = NVL(p_data_nasc, data_nasc)
        WHERE
            id_passageiro = p_id_passageiro;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20016, 'Passageiro com ID ' || p_id_passageiro || ' não encontrado para atualização.');
        END IF;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20017, 'Erro: CPF ' || p_cpf || ' já existe para outro passageiro.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20018, 'Erro ao atualizar passageiro: ' || SQLERRM);
    END ATUALIZAR_PASSAGEIRO;

    PROCEDURE REMOVER_PASSAGEIRO (
        p_id_passageiro IN NUMBER
    ) IS
        v_count NUMBER;
    BEGIN
        DELETE FROM passageiro WHERE id_passageiro = p_id_passageiro;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20019, 'Passageiro com ID ' || p_id_passageiro || ' não encontrado para remoção.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20020, 'Erro ao remover passageiro: ' || SQLERRM);
    END REMOVER_PASSAGEIRO;

    PROCEDURE INSERIR_ROTA (
        p_id_empresa      IN  NUMBER,
        p_descricao       IN  VARCHAR2,
        p_origem          IN  VARCHAR2,
        p_destino         IN  VARCHAR2,
        p_distancia_km    IN  NUMBER DEFAULT NULL,
        p_duracao_minutos IN  NUMBER DEFAULT NULL,
        p_ativa           IN  CHAR DEFAULT 'S',
        p_id_rota         OUT NUMBER
    ) IS
        v_empresa_existe NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_empresa_existe FROM empresa WHERE id_empresa = p_id_empresa;
        IF v_empresa_existe = 0 THEN
            RAISE_APPLICATION_ERROR(-20021, 'Erro: Empresa com ID ' || p_id_empresa || ' não encontrada.');
        END IF;
        INSERT INTO rota (id_empresa, descricao, origem, destino, distancia_km, duracao_minutos, ativa)
        VALUES (p_id_empresa, p_descricao, p_origem, p_destino, p_distancia_km, p_duracao_minutos, p_ativa)
        RETURNING id_rota INTO p_id_rota;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20022, 'Erro ao inserir rota: ' || SQLERRM);
    END INSERIR_ROTA;

    FUNCTION BUSCAR_ROTA_POR_ID (
        p_id_rota IN NUMBER
    ) RETURN ROTA%ROWTYPE IS
        v_rota ROTA%ROWTYPE;
    BEGIN
        SELECT * INTO v_rota FROM rota WHERE id_rota = p_id_rota;
        RETURN v_rota;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20023, 'Rota com ID ' || p_id_rota || ' não encontrada.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20024, 'Erro ao buscar rota: ' || SQLERRM);
    END BUSCAR_ROTA_POR_ID;

    PROCEDURE LISTAR_ROTAS (
        p_cursor OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_cursor FOR
            SELECT id_rota, id_empresa, descricao, origem, destino, distancia_km, duracao_minutos, ativa
            FROM rota;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20025, 'Erro ao listar rotas: ' || SQLERRM);
    END LISTAR_ROTAS;

    PROCEDURE ATUALIZAR_ROTA (
        p_id_rota         IN  NUMBER,
        p_id_empresa      IN  NUMBER DEFAULT NULL,
        p_descricao       IN  VARCHAR2 DEFAULT NULL,
        p_origem          IN  VARCHAR2 DEFAULT NULL,
        p_destino         IN  VARCHAR2 DEFAULT NULL,
        p_distancia_km    IN  NUMBER DEFAULT NULL,
        p_duracao_minutos IN  NUMBER DEFAULT NULL,
        p_ativa           IN  CHAR DEFAULT NULL
    ) IS
        v_count NUMBER;
        v_empresa_existe NUMBER;
    BEGIN
        IF p_id_empresa IS NOT NULL THEN
            SELECT COUNT(*) INTO v_empresa_existe FROM empresa WHERE id_empresa = p_id_empresa;
            IF v_empresa_existe = 0 THEN
                RAISE_APPLICATION_ERROR(-20026, 'Erro: Empresa com ID ' || p_id_empresa || ' não encontrada para atualização da rota.');
            END IF;
        END IF;
        UPDATE rota
        SET
            id_empresa      = NVL(p_id_empresa, id_empresa),
            descricao       = NVL(p_descricao, descricao),
            origem          = NVL(p_origem, origem),
            destino         = NVL(p_destino, destino),
            distancia_km    = NVL(p_distancia_km, distancia_km),
            duracao_minutos = NVL(p_duracao_minutos, duracao_minutos),
            ativa           = NVL(p_ativa, ativa)
        WHERE
            id_rota = p_id_rota;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20027, 'Rota com ID ' || p_id_rota || ' não encontrada para atualização.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20028, 'Erro ao atualizar rota: ' || SQLERRM);
    END ATUALIZAR_ROTA;

    PROCEDURE REMOVER_ROTA (
        p_id_rota IN NUMBER
    ) IS
        v_count NUMBER;
    BEGIN
        DELETE FROM rota WHERE id_rota = p_id_rota;
        v_count := SQL%ROWCOUNT;
        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20029, 'Rota com ID ' || p_id_rota || ' não encontrada para remoção.');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20030, 'Erro ao remover rota: ' || SQLERRM);
    END REMOVER_ROTA;
END tab_1_tab_6;
/