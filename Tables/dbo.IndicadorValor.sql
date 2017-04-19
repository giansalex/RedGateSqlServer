CREATE TABLE [dbo].[IndicadorValor]
(
[Cd_IV] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_TM] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IC_DetCab] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[NomCol] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[IB_EsNum] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndicadorValor] ADD CONSTRAINT [PK_IndicadorValor] PRIMARY KEY CLUSTERED  ([Cd_IV], [Cd_TM]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndicadorValor] WITH NOCHECK ADD CONSTRAINT [FK_IndicadorValor_TipoMov] FOREIGN KEY ([Cd_TM]) REFERENCES [dbo].[TipoMov] ([Cd_TM])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Es numerica', 'SCHEMA', N'dbo', 'TABLE', N'IndicadorValor', 'COLUMN', N'IB_EsNum'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicador Detalle/Cabecera (D/C)', 'SCHEMA', N'dbo', 'TABLE', N'IndicadorValor', 'COLUMN', N'IC_DetCab'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Columna', 'SCHEMA', N'dbo', 'TABLE', N'IndicadorValor', 'COLUMN', N'NomCol'
GO
