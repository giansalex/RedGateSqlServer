CREATE TABLE [dbo].[EstEnvClt]
(
[Id_EstEnvClt] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstEnvClt] ADD CONSTRAINT [PK_EstEnvClt] PRIMARY KEY CLUSTERED  ([Id_EstEnvClt]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Envio Cliente', 'SCHEMA', N'dbo', 'TABLE', N'EstEnvClt', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID Estado Envio Cliente', 'SCHEMA', N'dbo', 'TABLE', N'EstEnvClt', 'COLUMN', N'Id_EstEnvClt'
GO
