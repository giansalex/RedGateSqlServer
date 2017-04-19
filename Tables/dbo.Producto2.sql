CREATE TABLE [dbo].[Producto2]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre1] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre2] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[NCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta1] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta2] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CodCo1_] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[CodCo2_] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[CodCo3_] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[CodBarras] [varchar] (30) COLLATE Modern_Spanish_CI_AS NULL,
[FecCaducidad] [smalldatetime] NULL,
[Img] [image] NULL,
[StockMin] [numeric] (13, 3) NULL,
[StockMax] [numeric] (13, 3) NULL,
[StockAlerta] [numeric] (13, 3) NULL,
[StockActual] [numeric] (13, 3) NULL,
[StockCot] [numeric] (13, 3) NULL,
[StockSol] [numeric] (13, 3) NULL,
[Cd_TE] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Mca] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CL] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CLS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CLSS] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGP] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA03] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA04] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA05] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA06] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA07] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA08] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA09] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA10] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[IB_PT] [bit] NULL,
[IB_MP] [bit] NULL,
[IB_EE] [bit] NULL,
[IB_Srs] [bit] NULL,
[IB_PV] [bit] NULL,
[IB_PC] [bit] NULL,
[IB_AF] [bit] NULL,
[Cta3] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta4] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta5] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta6] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta7] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cta8] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IB_TR] [bit] NULL,
[PagWeb] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Producto2] ADD CONSTRAINT [PK_Producto2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Prod]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_Producto2_RucE_Nombre1] ON [dbo].[Producto2] ([RucE], [Nombre1]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Producto', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_CGP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Clase', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_CL'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Clase Sub', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_CLS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Clase Sub Sub', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_CLSS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cod. Tipo Existencia', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'Cd_TE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec ultima Mdf', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'FecMdf'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Activo Fijo', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_AF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Envase y Embalaje', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_EE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Materia Prima', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_MP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Producto para Compra', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_PC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Producto Terminado', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_PT'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Producto para Venta', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_PV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Maneja Series', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'IB_Srs'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stock reservado por cotizaciones', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'StockCot'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stock total solicitado', 'SCHEMA', N'dbo', 'TABLE', N'Producto2', 'COLUMN', N'StockSol'
GO
