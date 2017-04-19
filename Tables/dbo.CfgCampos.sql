CREATE TABLE [dbo].[CfgCampos]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Id_CTb] [int] NOT NULL,
[Id_TDt] [int] NOT NULL,
[Nom] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ValorDef] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[MaxCarac] [int] NULL,
[IB_Oblig] [bit] NULL,
[IB_Hab] [bit] NULL,
[MinDate] [datetime] NULL,
[MaxDate] [datetime] NULL,
[ValList] [varchar] (8000) COLLATE Modern_Spanish_CI_AS NULL,
[Fmla] [varchar] (300) COLLATE Modern_Spanish_CI_AS NULL,
[IB_Rpt] [bit] NULL,
[MaxValue] [decimal] (9, 4) NULL,
[MinValue] [decimal] (9, 4) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgCampos] ADD CONSTRAINT [PK_CfgCampos] PRIMARY KEY CLUSTERED  ([RucE], [Id_CTb]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CfgCampos] WITH NOCHECK ADD CONSTRAINT [FK_CfgCampos_CampoTabla] FOREIGN KEY ([Id_CTb]) REFERENCES [dbo].[CampoTabla] ([Id_CTb])
GO
ALTER TABLE [dbo].[CfgCampos] WITH NOCHECK ADD CONSTRAINT [FK_CfgCampos_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[CfgCampos] WITH NOCHECK ADD CONSTRAINT [FK_CfgCampos_TipoDato] FOREIGN KEY ([Id_TDt]) REFERENCES [dbo].[TipoDato] ([Id_TDt])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Campo Tabla', 'SCHEMA', N'dbo', 'TABLE', N'CfgCampos', 'COLUMN', N'Id_CTb'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Tipo Dato', 'SCHEMA', N'dbo', 'TABLE', N'CfgCampos', 'COLUMN', N'Id_TDt'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valores de la lista', 'SCHEMA', N'dbo', 'TABLE', N'CfgCampos', 'COLUMN', N'ValList'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Valor por Defecto', 'SCHEMA', N'dbo', 'TABLE', N'CfgCampos', 'COLUMN', N'ValorDef'
GO
