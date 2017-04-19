CREATE TABLE [dbo].[ComisionGrupVdr]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CGV] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ComisionGrupVdr] ADD CONSTRAINT [PK_ComisionGrupVdr] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CGV]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Codigo Comision Grupo Vendedor', 'SCHEMA', N'dbo', 'TABLE', N'ComisionGrupVdr', 'COLUMN', N'Cd_CGV'
GO
