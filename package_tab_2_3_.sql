-- Package Specification
CREATE OR REPLACE PACKAGE tab_2_tab_5 AS

    PROCEDURE insert_motorista (
        p_id_empresa      IN  motorista.id_empresa%TYPE,
        p_nome            IN  motorista.nome%TYPE,
        p_cpf             IN  motorista.cpf%TYPE,
        p_cnh             IN  motorista.cnh%TYPE,
        p_categoria_cnh   IN  motorista.categoria_cnh%TYPE,
        p_data_admissao   IN  motorista.data_admissao%TYPE,
        p_id_motorista    OUT motorista.id_motorista%TYPE
    );

    PROCEDURE update_motorista (
        p_id_motorista    IN motorista.id_motorista%TYPE,
        p_id_empresa      IN motorista.id_empresa%TYPE,
        p_nome            IN motorista.nome%TYPE,
        p_cpf             IN motorista.cpf%TYPE,
        p_cnh             IN motorista.cnh%TYPE,
        p_categoria_cnh   IN motorista.categoria_cnh%TYPE,
        p_data_admissao   IN motorista.data_admissao%TYPE
    );

    PROCEDURE delete_motorista (
        p_id_motorista    IN motorista.id_motorista%TYPE
    );

    FUNCTION get_motorista_by_id (
        p_id_motorista    IN motorista.id_motorista%TYPE
    ) RETURN motorista%ROWTYPE;

    PROCEDURE insert_veiculo (
        p_id_empresa      IN  veiculo.id_empresa%TYPE,
        p_placa           IN  veiculo.placa%TYPE,
        p_modelo          IN  veiculo.modelo%TYPE,
        p_marca           IN  veiculo.marca%TYPE,
        p_ano             IN  veiculo.ano%TYPE,
        p_capacidade      IN  veiculo.capacidade%TYPE,
        p_tipo            IN  veiculo.tipo%TYPE,
        p_id_veiculo      OUT veiculo.id_veiculo%TYPE
    );

    PROCEDURE update_veiculo (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE,
        p_id_empresa      IN veiculo.id_empresa%TYPE,
        p_placa           IN veiculo.placa%TYPE,
        p_modelo          IN veiculo.modelo%TYPE,
        p_marca           IN veiculo.marca%TYPE,
        p_ano             IN veiculo.ano%TYPE,
        p_capacidade      IN veiculo.capacidade%TYPE,
        p_tipo            IN veiculo.tipo%TYPE
    );

    PROCEDURE delete_veiculo (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE
    );

    FUNCTION get_veiculo_by_id (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE
    ) RETURN veiculo%ROWTYPE;

END tab_2_tab_5;
/


CREATE OR REPLACE PACKAGE BODY tab_2_tab_5 AS

    PROCEDURE insert_motorista (
        p_id_empresa      IN  motorista.id_empresa%TYPE,
        p_nome            IN  motorista.nome%TYPE,
        p_cpf             IN  motorista.cpf%TYPE,
        p_cnh             IN  motorista.cnh%TYPE,
        p_categoria_cnh   IN  motorista.categoria_cnh%TYPE,
        p_data_admissao   IN  motorista.data_admissao%TYPE,
        p_id_motorista    OUT motorista.id_motorista%TYPE
    ) IS
    BEGIN
        INSERT INTO motorista (
            id_empresa, nome, cpf, cnh, categoria_cnh, data_admissao
        ) VALUES (
            p_id_empresa, p_nome, p_cpf, p_cnh, p_categoria_cnh, p_data_admissao
        ) RETURNING id_motorista INTO p_id_motorista;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20001, 'Erro: CPF ou CNH já cadastrado para outro motorista.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Erro ao inserir motorista: ' || SQLERRM);
    END insert_motorista;


    PROCEDURE update_motorista (
        p_id_motorista    IN motorista.id_motorista%TYPE,
        p_id_empresa      IN motorista.id_empresa%TYPE,
        p_nome            IN motorista.nome%TYPE,
        p_cpf             IN motorista.cpf%TYPE,
        p_cnh             IN motorista.cnh%TYPE,
        p_categoria_cnh   IN motorista.categoria_cnh%TYPE,
        p_data_admissao   IN motorista.data_admissao%TYPE
    ) IS
        
        CURSOR c_motorista IS
            SELECT id_motorista
            FROM motorista
            WHERE id_motorista = p_id_motorista;

        v_rec c_motorista%ROWTYPE;
    BEGIN
        OPEN c_motorista;
        FETCH c_motorista INTO v_rec;

        IF c_motorista%NOTFOUND THEN
            CLOSE c_motorista;
            RAISE_APPLICATION_ERROR(-20003, 'Erro: Motorista com ID ' || p_id_motorista || ' não encontrado.');
        END IF;

        CLOSE c_motorista;

        UPDATE motorista
        SET
            id_empresa    = p_id_empresa,
            nome          = p_nome,
            cpf           = p_cpf,
            cnh           = p_cnh,
            categoria_cnh = p_categoria_cnh,
            data_admissao = p_data_admissao
        WHERE id_motorista = p_id_motorista;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20004, 'Erro: CPF ou CNH já cadastrado para outro motorista.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20005, 'Erro ao atualizar motorista: ' || SQLERRM);
    END update_motorista;


    PROCEDURE delete_motorista (
        p_id_motorista    IN motorista.id_motorista%TYPE
    ) IS
        
        CURSOR c_motorista IS
            SELECT id_motorista
            FROM motorista
            WHERE id_motorista = p_id_motorista;

        v_rec c_motorista%ROWTYPE;
    BEGIN
        OPEN c_motorista;
        FETCH c_motorista INTO v_rec;

        IF c_motorista%NOTFOUND THEN
            CLOSE c_motorista;
            RAISE_APPLICATION_ERROR(-20006, 'Erro: Motorista com ID ' || p_id_motorista || ' não encontrado.');
        END IF;

        CLOSE c_motorista;

        DELETE FROM motorista
        WHERE id_motorista = p_id_motorista;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20007, 'Erro ao deletar motorista: ' || SQLERRM);
    END delete_motorista;


    FUNCTION get_motorista_by_id (
        p_id_motorista    IN motorista.id_motorista%TYPE
    ) RETURN motorista%ROWTYPE IS
      
        CURSOR c_motorista IS
            SELECT *
            FROM motorista
            WHERE id_motorista = p_id_motorista;

        v_motorista motorista%ROWTYPE;
    BEGIN
        OPEN c_motorista;
        FETCH c_motorista INTO v_motorista;

        IF c_motorista%NOTFOUND THEN
            CLOSE c_motorista;
            RAISE_APPLICATION_ERROR(-20008, 'Erro: Motorista com ID ' || p_id_motorista || ' não encontrado.');
        END IF;

        CLOSE c_motorista;
        RETURN v_motorista;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20009, 'Erro ao buscar motorista: ' || SQLERRM);
    END get_motorista_by_id;


    PROCEDURE insert_veiculo (
        p_id_empresa      IN  veiculo.id_empresa%TYPE,
        p_placa           IN  veiculo.placa%TYPE,
        p_modelo          IN  veiculo.modelo%TYPE,
        p_marca           IN  veiculo.marca%TYPE,
        p_ano             IN  veiculo.ano%TYPE,
        p_capacidade      IN  veiculo.capacidade%TYPE,
        p_tipo            IN  veiculo.tipo%TYPE,
        p_id_veiculo      OUT veiculo.id_veiculo%TYPE
    ) IS
    BEGIN
        INSERT INTO veiculo (
            id_empresa, placa, modelo, marca, ano, capacidade, tipo
        ) VALUES (
            p_id_empresa, p_placa, p_modelo, p_marca, p_ano, p_capacidade, p_tipo
        ) RETURNING id_veiculo INTO p_id_veiculo;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20010, 'Erro: Placa já cadastrada para outro veículo.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20011, 'Erro ao inserir veículo: ' || SQLERRM);
    END insert_veiculo;


    PROCEDURE update_veiculo (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE,
        p_id_empresa      IN veiculo.id_empresa%TYPE,
        p_placa           IN veiculo.placa%TYPE,
        p_modelo          IN veiculo.modelo%TYPE,
        p_marca           IN veiculo.marca%TYPE,
        p_ano             IN veiculo.ano%TYPE,
        p_capacidade      IN veiculo.capacidade%TYPE,
        p_tipo            IN veiculo.tipo%TYPE
    ) IS
     
        CURSOR c_veiculo IS
            SELECT id_veiculo
            FROM veiculo
            WHERE id_veiculo = p_id_veiculo;

        v_rec c_veiculo%ROWTYPE;
    BEGIN
        OPEN c_veiculo;
        FETCH c_veiculo INTO v_rec;

        IF c_veiculo%NOTFOUND THEN
            CLOSE c_veiculo;
            RAISE_APPLICATION_ERROR(-20012, 'Erro: Veículo com ID ' || p_id_veiculo || ' não encontrado.');
        END IF;

        CLOSE c_veiculo;

        UPDATE veiculo
        SET
            id_empresa = p_id_empresa,
            placa      = p_placa,
            modelo     = p_modelo,
            marca      = p_marca,
            ano        = p_ano,
            capacidade = p_capacidade,
            tipo       = p_tipo
        WHERE id_veiculo = p_id_veiculo;

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20013, 'Erro: Placa já cadastrada para outro veículo.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20014, 'Erro ao atualizar veículo: ' || SQLERRM);
    END update_veiculo;


    PROCEDURE delete_veiculo (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE
    ) IS
    
        CURSOR c_veiculo IS
            SELECT id_veiculo
            FROM veiculo
            WHERE id_veiculo = p_id_veiculo;

        v_rec c_veiculo%ROWTYPE;
    BEGIN
        OPEN c_veiculo;
        FETCH c_veiculo INTO v_rec;

        IF c_veiculo%NOTFOUND THEN
            CLOSE c_veiculo;
            RAISE_APPLICATION_ERROR(-20015, 'Erro: Veículo com ID ' || p_id_veiculo || ' não encontrado.');
        END IF;

        CLOSE c_veiculo;

        DELETE FROM veiculo
        WHERE id_veiculo = p_id_veiculo;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20016, 'Erro ao deletar veículo: ' || SQLERRM);
    END delete_veiculo;


    FUNCTION get_veiculo_by_id (
        p_id_veiculo      IN veiculo.id_veiculo%TYPE
    ) RETURN veiculo%ROWTYPE IS
  
        CURSOR c_veiculo IS
            SELECT *
            FROM veiculo
            WHERE id_veiculo = p_id_veiculo;

        v_veiculo veiculo%ROWTYPE;
    BEGIN
        OPEN c_veiculo;
        FETCH c_veiculo INTO v_veiculo;

        IF c_veiculo%NOTFOUND THEN
            CLOSE c_veiculo;
            RAISE_APPLICATION_ERROR(-20017, 'Erro: Veículo com ID ' || p_id_veiculo || ' não encontrado.');
        END IF;

        CLOSE c_veiculo;
        RETURN v_veiculo;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20018, 'Erro ao buscar veículo: ' || SQLERRM);
    END get_veiculo_by_id;

END tab_2_tab_5;
/