drop schema if exists dev_farmacia;
create schema dev_farmacia;

use dev_farmacia;

create table fabricante(
	codFabricante integer,
    nome varchar(128) not null,
    primary key (codFabricante)
);

create table fornecedor(
	codFornecedor integer,
    nome varchar(128) not null,
    primary key (codFornecedor)
);

create table fornecedor_fabricante(
	codFabricante integer,
	codFornecedor integer,
	primary key (codFabricante,codFornecedor),
    constraint forn_fabricante foreign key(codFabricante) references fabricante(codFabricante),
    constraint fabr_fornecedor foreign key(codFornecedor) references fornecedor(codFornecedor)
);

create table lote(
	codLote integer,
    lote varchar(64) not null,
    data timestamp,
    codFornecedor integer,
    primary key (codLote),
	constraint lote_fornecedor foreign key(codFornecedor) references fornecedor(codFornecedor)
);

create table produto(
	codProduto integer,
    nome varchar(128) not null,
    codigo varchar(128) not null,
    codFabricante integer,
    primary key(codProduto),
    constraint prod_fabricante foreign key(codFabricante) references fabricante(codFabricante)
);

create table produto_lote(
	codProduto integer,
    codLote integer,
    primary key (codProduto,codLote),
    constraint lote_Produto foreign key(codProduto) references produto(codProduto),
    constraint produto_Lote foreign key(codLote) references lote(codLote)
);

create table Medicamento(
	codProduto integer,
    tipo varchar(128) not null,
    retemReceita bool,
    primary key (codProduto),
    constraint med_Produto foreign key(codProduto) references produto(codProduto)
);

create table Perfumaria(
	codProduto integer,
    tipo varchar(128) not null,
    primary key (codProduto),
    constraint perf_Produto foreign key(codProduto) references produto(codProduto)
);

create table Venda(
	codVenda integer,
    data timestamp not null,
    valorTotal double not null,
    Cliente varchar(128),
    CPF varchar(15),
    primary key (codVenda)
);

create table Receita(
	codReceita integer,
    dataReceita timestamp not null,
    medico varchar(128) not null,
    paciente varchar(128) not null,
    fotoReceitaPath varchar(2048),
    primary key (codReceita)
);

create table ItemMedicamento(
	codProduto integer,
    codVenda integer,
    codReceita integer default null,
    primary key (codProduto,codVenda),
    constraint item_Medicamento foreign key(codProduto) references Medicamento(codProduto),
    constraint itemMed_Venda foreign key(codVenda) references Venda(codVenda),
    constraint rec_Item foreign key(codReceita) references Receita(codReceita)
);

create table ItemPerfumaria(
	codProduto integer,
    codVenda integer,
    primary key (codProduto,codVenda),
    constraint item_Perfumaria foreign key(codProduto) references Perfumaria(codProduto),
    constraint itemPerf_Venda foreign key(codVenda) references Venda(codVenda)
);



-- ---------------------------------------------------------------------------------------------------------------
-- Adicionando a tabela Cliente, alterando as tabelas existentes e criando o relacionamento entre Vendas e Cliente
use dev_farmacia;

create table Cliente(
	codCliente integer,
    data_nasc timestamp ,
    Cliente varchar(128),
    CPF varchar(15),
    primary key (codCliente)
);

alter table Venda drop column Cliente;
alter table Venda drop column cpf;
alter table Venda add column codCliente integer default null;

alter table Venda add constraint Cliente_Venda foreign key(codCliente) references Cliente(codCliente);




-- ----------------------------------------------------------------------------------------------
-- Adicionando uma nova coluna, preco, no produto, ItemMedicamento e ItemPerfumaria
use dev_farmacia;

alter table produto
add column preco double not null default 0.0;

alter table ItemMedicamento
add column preco double not null default 0.0;

alter table ItemPerfumaria
add column preco double not null default 0.0;



-- -----------------------------------------------------------------------------------------------
-- Adicionando a tabela Delivery
use dev_farmacia;

create table Delivery(
	codDelivery integer auto_increment,
    nomeEntregador varchar(128) not null,
    tipoDePagamento char(1) not null default 0, -- 1 dinheiro,  2 cartao debito, 3 cartao credito
    valorTotal double not null,
    trocoPara double,
    bandeiraCartao varchar(10),
    enderecoEntrega varchar(512),
    telefoneContato varchar(20),
    dataEntrega timestamp,
    recebidoPor varchar(16),
    codVenda integer not null,
    primary key (codDelivery),
    constraint delivery_venda foreign key(codVenda) references Venda(codVenda)
);


-- b)	Alterações no esquema
-- a.	Nas tabelas de ItemMedicamento e ItemPerfumaria, adicionar o campo Quantidade, com valor default 1
alter table ItemMedicamento add column quantidade double default 1.0;

alter table ItemPerfumaria add column quantidade double default 1.0;

-- b.	Nas tabelas Medicamento e Perfumaria, adicionar o campo: estoque_minimo  e   preco_minimo
alter table Medicamento add column estoqueMinimo double;
alter table Medicamento add column precoMinimo double;

alter table Perfumaria add column estoqueMinimo double;
alter table Perfumaria add column precoMinimo double;

-- c.	Criar um índice para nome do produto.
alter table produto
add index produto_nome
(nome ASC);

-- d.	Criar uma restrição de unicidade (UNIQUE) para cpf do Cliente na tabela Cliente.
alter table Cliente
add unique Cliente_cpf
(cpf ASC);

-- e.	Mudar o campo nr. Entrega para autoincremento.
-- ja foi definido na criacao da tabela, mas caso nao fosse, seria o comando abaixo
-- alter table Delivery modify codDelivery integer auto_increment ;
-- alter table Delivery auto_increment = 1;

-- f.	Acrescentar o atributo CRM do médico e data de nascimento do paciente na tabela Receita.
alter table Receita add column crm varchar(32);
alter table Receita add column pacienteDataNascimento timestamp;

-- g.	Na tabela fornecedor, incluir os atributos necessários para o endereço completo, contato e email.
alter table fornecedor add column endereco varchar(256);
alter table fornecedor add column telefone varchar(32);
alter table fornecedor add column contato varchar(32);
alter table fornecedor add column email varchar(128);

-- h.	Incluir data de validade do produto e um atributo tipo: perecível ou não.
alter table produto add column dataValidade timestamp;
alter table produto add column perecivel boolean default false;