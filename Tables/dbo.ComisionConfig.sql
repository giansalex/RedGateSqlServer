CREATE TABLE [dbo].[ComisionConfig]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_CC] [int] NOT NULL,
[Cd_CGP] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGC] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Cd_CGV] [char] (3) COLLATE Modern_Spanish_CI_AS NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Imp] [numeric] (13, 2) NULL,
[Porc] [numeric] (5, 2) NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComisionConfig] ADD CONSTRAINT [PK_ComisionConfig] PRIMARY KEY CLUSTERED  ([RucE], [ID_CC]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComisionConfig] ADD CONSTRAINT [FK_ComisionConfig_ComisionGrupCte] FOREIGN KEY ([RucE], [Cd_CGC]) REFERENCES [dbo].[ComisionGrupCte] ([RucE], [Cd_CGC])
GO
ALTER TABLE [dbo].[ComisionConfig] ADD CONSTRAINT [FK_ComisionConfig_ComisionGrupProd] FOREIGN KEY ([RucE], [Cd_CGP]) REFERENCES [dbo].[ComisionGrupProd] ([RucE], [Cd_CGP])
GO
ALTER TABLE [dbo].[ComisionConfig] ADD CONSTRAINT [FK_ComisionConfig_ComisionGrupVdr] FOREIGN KEY ([RucE], [Cd_CGV]) REFERENCES [dbo].[ComisionGrupVdr] ([RucE], [Cd_CGV])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Cliente', 'SCHEMA', N'dbo', 'TABLE', N'ComisionConfig', 'COLUMN', N'Cd_CGC'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Producto', 'SCHEMA', N'dbo', 'TABLE', N'ComisionConfig', 'COLUMN', N'Cd_CGP'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Vendedor', 'SCHEMA', N'dbo', 'TABLE', N'ComisionConfig', 'COLUMN', N'Cd_CGV'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Id Comision Config', 'SCHEMA', N'dbo', 'TABLE', N'ComisionConfig', 'COLUMN', N'ID_CC'
GO
