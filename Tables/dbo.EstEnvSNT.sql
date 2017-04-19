CREATE TABLE [dbo].[EstEnvSNT]
(
[Id_EstEnvSNT] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (100) COLLATE Modern_Spanish_CI_AS NOT NULL,
[IB_Activo] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EstEnvSNT] ADD CONSTRAINT [PK_EstEnvSNT] PRIMARY KEY CLUSTERED  ([Id_EstEnvSNT]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estado Envio SUNAT', 'SCHEMA', N'dbo', 'TABLE', N'EstEnvSNT', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID Estado Envio Sunat', 'SCHEMA', N'dbo', 'TABLE', N'EstEnvSNT', 'COLUMN', N'Id_EstEnvSNT'
GO
