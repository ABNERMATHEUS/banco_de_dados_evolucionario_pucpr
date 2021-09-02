INSERT INTO `dev_farmacia`.`fabricante`
(`codFabricante`,`nome`)
VALUES
(1,'EKS'),
(2,'BIO Farm'),
(3,'Tech Farm');

INSERT INTO `dev_farmacia`.`fornecedor`
(`codFornecedor`,`nome`)
VALUES
(1,'Deposito Farm'),
(2,'Super Farm Dist');

INSERT INTO `dev_farmacia`.`fornecedor_fabricante`
(`codFabricante`,`codFornecedor`)
VALUES
(1,1),
(2,1),(2,2),(3,2);

INSERT INTO `dev_farmacia`.`produto`
(`codProduto`,`nome`,`codigo`,`codFabricante`,`dataValidade`)
VALUES
(1,'Acido Acetil Salicilico','123-2345',1,'2022-01-01'),
(2,'Acido Acetil Salicilico','123-2346',2,'2021-01-01'),
(3,'Acido Acetil Salicilico','123-2347',3,'2020-01-01'),
(4,'Gaze','523-6234',1,'2022-01-01'),
(5,'Shampoo','523-6235',3,'2024-01-01'),
(6,'Esmalte','522-7777',2,'2020-04-10'),
(7,'Antibiotico DuBom','007-0007',2,'2021-01-01');

INSERT INTO `dev_farmacia`.`Medicamento`
(`codProduto`,`tipo`,`retemReceita`)
VALUES
(1,'Anti-termico',False),
(2,'Anti-termico',False),
(3,'Anti-termico',False),
(4,'Primeiros Socorros',False),
(7,'Antibiotico',True);

INSERT INTO `dev_farmacia`.`Perfumaria`
(`codProduto`,`tipo`)
VALUES
(5,'Cuidados Pessoais'),
(6,'Cuidados Pessoais');

INSERT INTO `dev_farmacia`.`lote`
(`codLote`,`lote`,`data`,`codFornecedor`)
VALUES
(1,'2020001','2020-02-01',1),
(2,'2020101','2020-02-07',2),
(3,'2020102','2020-02-11',2);

INSERT INTO `dev_farmacia`.`produto_lote`
(`codProduto`,`codLote`)
VALUES
(1,1),
(1,3),(4,3),(6,3),
(3,2),(5,2),(7,2);




-- Venda 1
INSERT INTO `dev_farmacia`.`Cliente`
(`codCliente`,`data_nasc`,`cliente`,`CPF`)
VALUES
(1,'2000-01-10','Joao','123.234.345-67');

INSERT INTO `dev_farmacia`.`Venda`
(`codVenda`,`data`,`valorTotal`,`codCliente`)
VALUES
(1,'2020-02-28',123.34,1);

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`)
VALUES
(3,1),(4,1);

INSERT INTO `dev_farmacia`.`ItemPerfumaria`
(`codProduto`,`codVenda`)
VALUES
(5,1);


-- Venda 2
INSERT INTO `dev_farmacia`.`Cliente`
(`codCliente`,`data_nasc`,`cliente`,`CPF`)
VALUES
(2,'1987-01-10','Jose','434.235.234-67');

INSERT INTO `dev_farmacia`.`Venda`
(`codVenda`,`data`,`valorTotal`,`codcliente`)
VALUES
(2,'2020-02-29',78.25,2);

INSERT INTO `dev_farmacia`.`Receita`
(`codReceita`,`dataReceita`,`medico`,`paciente`,`fotoReceitaPath`)
VALUES
(1,'2020-02-02','Dr. Joao','Seu Chico','server://dev_farmacia`/receitas/0-2-7-receita.jpg');

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`,`codReceita`)
VALUES
(7,2,1);


--


use dev_farmacia;

-- lista produtos da dev_farmacia`
select p.codigo, p.nome
from produto p;


-- lista produtos da dev_farmacia`, com fabricante
select p.codigo as CodProduto, p.nome as Produto, f.nome as Fabricante
from produto p
inner join fabricante f on p.codFabricante = f.codFabricante;

-- lista produtos da dev_farmacia`, com fabricante, fornecedores e lotes
select p.codigo as CodProduto, p.nome as Produto
     , f.nome as Fabricante
     , l.lote as Lote
     , fn.nome as Fornecedor
from produto p
inner join fabricante f on p.codFabricante = f.codFabricante
inner join lote l
inner join produto_lote pl on pl.codProduto = p.codProduto
                           and l.codLote = pl.codLote
inner join fornecedor fn on fn.codFornecedor = l.codFornecedor;



--  lista produtos da dev_farmacia`, com fabricante, fornecedores e lotes sem usar join (idem anterior)
select p.codigo as CodProduto, p.nome as Produto
     , f.nome as Fabricante
     , l.lote as Lote
     , fn.nome as Fornecedor
from produto as p, fabricante as f, produto_lote as pl, fornecedor as fn, lote as l
where
 p.codFabricante = f.codFabricante and
 pl.codProduto = p.codProduto and
    l.codLote = pl.codLote and
 fn.codFornecedor = l.codFornecedor;

-- Vendas de Medicamentos
select v.codcliente, v.data
     , p.codigo, p.nome
from Venda as v
inner join ItemMedicamento im on im.codVenda = v.codVenda
inner join Medicamento m on m.codProduto = im.codProduto
inner join produto p on p.codProduto = m.codProduto;

-- Vendas de perfumaria
select v.codcliente, v.data
     , p.codigo, p.nome
from Venda as v
inner join ItemPerfumaria ip on ip.codVenda = v.codVenda
inner join Perfumaria pf on ip.codProduto = pf.codProduto
inner join produto p on p.codProduto = pf.codProduto;

-- vendas gerais
select v.codVenda, v.codcliente, v.data
     , p.codigo, p.nome
from Venda as v
inner join ItemMedicamento im on im.codVenda = v.codVenda
inner join Medicamento m on m.codProduto = im.codProduto
inner join produto p on p.codProduto = m.codProduto
union all
select v.codVenda, v.codcliente, v.data
     , p.codigo, p.nome
from Venda as v
inner join ItemPerfumaria ip on ip.codVenda = v.codVenda
inner join Perfumaria pf on ip.codProduto = pf.codProduto
inner join produto p on p.codProduto = pf.codProduto;



-- vendas gerais, ordenado por vendas
select venda, cliente, data
	 , codProd, produto
from (
	select v.codVenda as venda, v.codcliente as cliente, v.data as data
		 , p.codigo as codProd, p.nome as produto
	from Venda as v
	inner join ItemMedicamento im on im.codVenda = v.codVenda
	inner join Medicamento m on m.codProduto = im.codProduto
	inner join produto p on p.codProduto = m.codProduto
	union all
	select v.codVenda as venda, v.codcliente as cliente, v.data as data
		 , p.codigo as codProd, p.nome as produto
	from Venda as v
	inner join ItemPerfumaria ip on ip.codVenda = v.codVenda
	inner join Perfumaria pf on ip.codProduto = pf.codProduto
	inner join produto p on p.codProduto = pf.codProduto
) as vv
order by venda;


-- vendas gerais, ordenado por vendas, com receitas
select venda, cliente, data
	 , codProd, produto
     , medico, receita
from (
	select v.codVenda as venda, v.codcliente as cliente, v.data as data
		 , p.codigo as codProd, p.nome as produto
         , coalesce(r.medico,'-') as Medico, coalesce(r.fotoreceitapath,'-') as receita
	from Venda as v
	inner join ItemMedicamento im on im.codVenda = v.codVenda
	inner join Medicamento m on m.codProduto = im.codProduto
	inner join produto p on p.codProduto = m.codProduto
    left join Receita r on r.codReceita = im.codReceita
	union all
	select v.codVenda as venda, v.codcliente as cliente, v.data as data
		 , p.codigo as codProd, p.nome as produto
         , '-' as medico, '-' as receita
	from Venda as v
	inner join ItemPerfumaria ip on ip.codVenda = v.codVenda
	inner join Perfumaria pf on ip.codProduto = pf.codProduto
	inner join produto p on p.codProduto = pf.codProduto
) as vv
order by venda;






-- ajusta o preco dos produtos
select * from produto;
update produto set preco = 5.67 where codProduto in (1,2,3);
update produto set preco = 3.33 where codProduto = 4;
update produto set preco = 17.89 where codProduto = 5;
update produto set preco = 12.22 where codProduto = 6;
update produto set preco = 101.15 where codProduto = 7;




-- exclui o produto codigo=7; erro por chave estrangeira, pois está relacionado em produto lote.
-- DELETE FROM `dev_farmacia`.`produto`
-- WHERE codProduto=7;
-- exclui o produto codigo=2; erro por chave estrangeira, pois está relacionado em produto Medicamento
-- DELETE FROM `dev_farmacia`.`produto`
-- WHERE codProduto= 2;

INSERT INTO `dev_farmacia`.`produto`
(`codProduto`,`nome`,`codigo`,`codFabricante`)
VALUES
(8,'Dorflex-2345','454523-2347', 3),
(9,'Creme dental','66775123-2347',2) ;

-- exclui o produto codigo=8; permite excluir
DELETE FROM `dev_farmacia`.`produto`
WHERE codProduto= 8;



-- ajusta o preco dos itens ja vendidos de Medicamentos
select * from ItemMedicamento;
update ItemMedicamento set preco = 5.67 where codProduto = 3;
update ItemMedicamento set preco = 3.33 where codProduto = 4;
update ItemMedicamento set preco = 101.15 where codProduto = 7;
-- ou
/*update ItemMedicamento as im
set preco = (select prod.preco
			 from produto prod
             where im.codProduto = prod.CodProduto);*/

-- ajusta o preco dos itens ja vendidos de perfumarias
select * from ItemPerfumaria;
/*update ItemPerfumaria as ip
set preco = (select prod.preco
			 from produto prod
             where ip.codProduto = prod.CodProduto);*/

-- recalcular o valor total da venda, utilizando os precos corrigidos dos produtos
select * from Venda;
select * from ItemMedicamento;
select * from ItemPerfumaria;

-- select para calculo do total da venda
select codVenda, sum(preco)
from (
	select vd.codVenda, im.preco
	from Venda vd
	inner join ItemMedicamento im
	where im.codVenda = vd.codVenda

	union all

	select vd.codVenda, ip.preco
	from Venda vd
	inner join ItemPerfumaria ip
	where ip.codVenda = vd.codVenda) vd
group by codVenda;

-- atualizacao do valor total da venda
select * from Venda;

update Venda vdd
set valorTotal = ( select sum(preco)
					from (
						select vd.codVenda, im.preco
						from Venda vd
						inner join ItemMedicamento im
						where im.codVenda = vd.codVenda

						union all

						select vd.codVenda, ip.preco
						from Venda vd
						inner join ItemPerfumaria ip
						where ip.codVenda = vd.codVenda) vd
					where vd.codVenda = vdd.codVenda
					group by codVenda
				 );




-- ---------------------------------------------------------------------------------------
-- vendas com delivery
-- Venda 10
INSERT INTO `dev_farmacia`.`Cliente`
(`codCliente`,`data_nasc`,`cliente`,`CPF`)
VALUES
(10,'2000-01-11','J.Joao','234.234.345-67');

INSERT INTO `dev_farmacia`.`Venda`
(`codVenda`,`data`,`valorTotal`,`codCliente`)
VALUES
(10,'2020-03-28',100.00,10);

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(3,10,1,5.67),(4,10,1,3.33);

INSERT INTO `dev_farmacia`.`ItemPerfumaria`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(5,10,1,17.89);

INSERT INTO `dev_farmacia`.`Delivery`
(`nomeEntregador`,`tipoDePagamento`,`valorTotal`,`trocoPara`,`bandeiraCartao`,`enderecoEntrega`,
`telefoneContato`,`dataEntrega`,`recebidoPor`,`codVenda`)
VALUES
('John',1,100.00,0.0,'','Rua da Paz, 100','41-0000-0000','2020-04-01 22.30','Porteiro',10);


-- vendas com delivery
-- Venda 11
INSERT INTO `dev_farmacia`.`Venda`
(`codVenda`,`data`,`valorTotal`,`codCliente`)
VALUES
(11,'2020-03-28',100.00,10);

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(3,11,1,5.67),(4,11,1,3.33);

INSERT INTO `dev_farmacia`.`ItemPerfumaria`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(5,11,1,17.89);

INSERT INTO `dev_farmacia`.`Delivery`
(`nomeEntregador`,`tipoDePagamento`,`valorTotal`,`trocoPara`,`bandeiraCartao`,`enderecoEntrega`,
`telefoneContato`,`dataEntrega`,`recebidoPor`,`codVenda`)
VALUES
('John',1,100.00,0.0,'','Rua da Paz, 100','41-0000-0000','2020-04-01 22.30','Porteiro',11);




-- vendas com delivery
-- Venda 12
INSERT INTO `dev_farmacia`.`Cliente`
(`codCliente`,`data_nasc`,`cliente`,`CPF`)
VALUES
(11,'2001-01-11','H.Joao','635.234.345-67');

INSERT INTO `dev_farmacia`.`Venda`
(`codVenda`,`data`,`valorTotal`,`codCliente`)
VALUES
(12,'2020-03-28',10.00,11);

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(1,12,3,5.67),(4,12,7,3.33);


INSERT INTO `dev_farmacia`.`Receita`
(`codReceita`,
`dataReceita`,
`medico`,
`paciente`,
`fotoReceitaPath`,
`crm`,
`pacienteDataNascimento`)
VALUES
(2,'2020-01-02','Dr. Joao','Filho seu Chico','server://dev_farmacia`/receitas/0-2-8-receita.jpg','413543-1','2005-05-10');

INSERT INTO `dev_farmacia`.`ItemMedicamento`
(`codProduto`,`codVenda`,`codReceita`,`quantidade`,`preco`)
VALUES
(7,12,2,1,101.15);

INSERT INTO `dev_farmacia`.`ItemPerfumaria`
(`codProduto`,`codVenda`,`quantidade`,`preco`)
VALUES
(5,12,2,17.89);

INSERT INTO `dev_farmacia`.`Delivery`
(`nomeEntregador`,`tipoDePagamento`,`valorTotal`,`trocoPara`,`bandeiraCartao`,`enderecoEntrega`,
`telefoneContato`,`dataEntrega`,`recebidoPor`,`codVenda`)
VALUES
('JohnJohn',1,23.00,0.0,'','Rua da Paz, 110','51-0000-0000','2020-04-01 23.30','Porteiro',12);
