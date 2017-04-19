CREATE TABLE [dbo].[OrdFabricacion]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_OF] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NroOF] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[FecE] [smalldatetime] NULL,
[FecEntR] [smalldatetime] NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Prod] [char] (7) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Alm] [varchar] (20) COLLATE Modern_Spanish_CI_AS NULL,
[ID_UMP] [int] NULL,
[ID_Fmla] [int] NULL,
[Asunto] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[Obs] [varchar] (1000) COLLATE Modern_Spanish_CI_AS NULL,
[Lote] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CosTot] [numeric] (15, 7) NULL CONSTRAINT [DF_OrdFabricacion2_Valor] DEFAULT ((0)),
[CosTot_ME] [numeric] (15, 7) NULL CONSTRAINT [DF_OrdFabricacion_CosTot1] DEFAULT ((0)),
[Cant] [numeric] (15, 7) NULL CONSTRAINT [DF_OrdFabricacion2_BIM] DEFAULT ((0)),
[CU] [numeric] (15, 7) NULL CONSTRAINT [DF_OrdFabricacion2_Total] DEFAULT ((0)),
[CU_ME] [numeric] (15, 7) NULL CONSTRAINT [DF_OrdFabricacion_CU1] DEFAULT ((0)),
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NULL,
[CamMda] [numeric] (6, 3) NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuModf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SC] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_SS] [nvarchar] (8) COLLATE Modern_Spanish_CI_AS NULL,
[Id_EstOF] [char] (2) COLLATE Modern_Spanish_CI_AS NULL,
[TipAut] [int] NULL,
[IB_Aut] [bit] NULL,
[AutorizadoPor] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
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
[CdOF_Base] [char] (10) COLLATE Modern_Spanish_CI_AS NULL,
[CA11] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA12] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA13] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA14] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA15] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[CA16] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA17] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA18] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA19] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA20] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA21] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA22] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA23] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA24] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[CA25] [varchar] (4000) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdFabricacion] ADD CONSTRAINT [PK_OrdFabricacion2] PRIMARY KEY CLUSTERED  ([RucE], [Cd_OF]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrdFabricacion] ADD CONSTRAINT [FK_OrdFabricacion_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[OrdFabricacion] ADD CONSTRAINT [FK_OrdFabricacion_Formula] FOREIGN KEY ([RucE], [ID_Fmla]) REFERENCES [dbo].[Formula] ([RucE], [ID_Fmla])
GO
ALTER TABLE [dbo].[OrdFabricacion] WITH NOCHECK ADD CONSTRAINT [FK_OrdFabricacion2_EstadoOF] FOREIGN KEY ([Id_EstOF]) REFERENCES [dbo].[EstadoOF] ([Id_EstOF])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cantidad a Producir', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Cant'
GO
EXEC sp_addextendedproperty N'MS_Description', N'C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Cd_CC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF00000001', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Cd_OF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Cd_SC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sub Sub C. Costo', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Cd_SS'
GO
EXEC sp_addextendedproperty N'MS_Description', N'OF que modifica', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'CdOF_Base'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fecha Emision', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'FecE'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Fec. de Entrega Requerida', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'FecEntR'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Autorizado', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'IB_Aut'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Orden de Compra', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'Id_EstOF'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tipo Autorizable', 'SCHEMA', N'dbo', 'TABLE', N'OrdFabricacion', 'COLUMN', N'TipAut'
GO
