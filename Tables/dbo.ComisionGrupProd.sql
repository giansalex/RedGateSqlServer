CREATE TABLE [dbo].[ComisionGrupProd]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CGP] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComisionGrupProd] ADD CONSTRAINT [PK_ComisionGrupProd] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CGP]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Producto', 'SCHEMA', N'dbo', 'TABLE', N'ComisionGrupProd', 'COLUMN', N'Cd_CGP'
GO
