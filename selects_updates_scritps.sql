-- capitulo 3

postgres=> select * from mesas;

postgres=> select mesa_codigo, data_criacao from mesas;

postgres=> select * from mesas where mesa_codigo = '00002';

postgres=> update produtos set produto_valor = 4 where id = 2;

postgres=> update produtos set data_criacao = '31/12/2016';

postgres=> select data_criacao from produtos;

postgres=> delete from mesas where id = 2;

-- capitulo 4

postgres=# create or replace function 
            retorna_nome_funcionario(func_id int) 
            returns text as 
            $$              
            declare 
            nome     text;   
            situacao text;
            begin
			
              select funcionario_nome,
                     funcionario_situacao
                into nome, situacao
                from funcionarios
               where id = func_id;	
	           
               if situacao = 'A' then
                 return nome || ' Usuário Ativo';                 
               else                  
                 return nome || ' Usuário Inativo';                 
               end if;  
			   
            end
            $$ 
            language plpgsql;
			
postgresql=> select retorna_nome_funcionario(1);



postgresql=> create or replace function 
            rt_valor_comissao(func_id int)
            returns real as 
            $$
            declare             
              valor_comissao real;
             
            begin              
              select funcionario_comissao
                into valor_comissao
                from funcionarios
               where id = func_id;               
               return valor_comissao;
            end
            $$
            LANGUAGE plpgsql;

postgresql=> select rt_valor_comissao(1);


create or replace function 
             calc_comissao(data_ini timestamp,
                           data_fim timestamp)
             returns void as $$
             declare 
            
            -- declaração das variáveis que iremos
            -- utilizar. Já na declaração elas
            -- recebem o valor zero. Pois assim
            -- garanto que elas estarão zeradas
            -- quando for utiliza-las.
            
               total_comissao  real := 0;
               porc_comissao   real := 0;
			   
			-- declarando uma variavel para armazenar 
			-- os registros dos loop
			   reg             record;
               
            --cursor para buscar a % de comissão do funcionario
            
              cr_porce CURSOR (func_id int) IS 
                  select rt_valor_comissao(func_id);

             begin
            
            -- realiza um loop e busca todas as vendas
            --  no pereíodo informado
            
                for reg in( 
                  select vendas.id id,
                         funcionario_id,
                         venda_total
                    from vendas
                   where data_criacao >= data_ini
                     and data_criacao <= data_fim 
                     and venda_situacao = 'A')loop         
            
            -- abertura, utilização e fechamento do cursor
            
                  open cr_porce(reg.funcionario_id);
                  fetch cr_porce into porc_comissao;
                  close cr_porce;
                  
                             
                  total_comissao := (reg.venda_total * 
                                    porc_comissao)/100;
                 
            -- insere na tabela de comissoes o valor 
            -- que o funcionario ira receber de comissao
            -- daquela venda
            
                  insert into comissoes(
                                        funcionario_id,
                                        comissao_valor,
                                        comissao_situacao,
                                        data_criacao,
                                        data_atualizacao) 
                  values(reg.funcionario_id,
                         total_comissao,
                         'A',
                         now(),
                         now());
            
            -- update na situacao da venda 
            -- para que ela não seja mais comissionada
            
                  update vendas set venda_situacao = 'C'
                   where id = reg.id;
            
            -- devemos zerar as variáveis para reutiliza-las
            
                   total_comissao := 0;
                   porc_comissao  := 0;
                  
            -- termino do loop
            
                end loop;                                    
             
             end
             $$ language plpgsql;

postgresql=> select calc_comissao('01/01/2016 00:00:00','01/01/2016 00:00:00');

postgresql=> select comissao_valor,
                    data_criacao
               from comissoes;

postgresql=> drop function calc_comissoes();    

-- capitulo 5

   select venda_id,
          funcionario_id,
          venda_total
    from  vendas
   where data_criacao >= 'data_ini'
     and data_criacao <= 'data_fim'
     and produto_situacao = 'A'
	 
postgres=> insert into produtos (produto_codigo,
                                 produto_nome,
                                 produto_valor,
                                 produto_situacao,
                                 data_criacao,
                                 data_atualizacao)
                          values ('2832',
                                  'SUCO DE LIMÃO',
                                   15,
                                  'C',
                                  '02/02/2016',
                                  '02/02/2016');

postgres=> select * 
             from produtos
            where produto_situacao = 'A'
              and produto_situacao = 'C';

postgres=> select * 
             from produtos
            where produto_situacao = 'A'
               or produto_situacao = 'C';

postgres=> select * 
             from produtos
            where not produto_nome = 'SUCO DE LIMÃO';

postgres=> select * 
             from produtos
            where produto_situacao = 'A' 
               or (produto_situacao = 'C' 
                   and data_criacao = '02/02/2016');

select id,
       funcionario_id,
       venda_total
  from vendas
 where data_criacao >= 'data_ini'
   and data_criacao <= 'data_fim'
   and venda_situacao = 'A';

select id,
       funcionario_id,
       venda_total
  from vendas
 where data_criacao >= '01/01/2016'
   and data_criacao < '02/02/2016'
   and venda_situacao = 'A';


postgres=# select funcionario_codigo || funcionario_nome 
               from funcionarios
              where id = 1;

select (funcionario_codigo ||' '|| funcionario_nome)
  from funcionarios
  where id = 1;

select (funcionario_codigo ||8|| funcionario_nome)
  from funcionarios
  where id = 1;


postgres=# select char_length(funcionario_nome)
               from funcionarios
              where id = 2;

postgres=# select upper(funcionario_nome)
               from funcionarios;

postgres=# select upper('livro postgresql');

postgres=# select initcap('livro postgresql');

postgres=# select lower(funcionario_nome)
              from funcionarios;			   
-- capitulo 6
-- capitulo 7
-- capitulo 8
-- capitulo 9
-- capitulo 10
