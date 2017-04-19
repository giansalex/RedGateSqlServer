CREATE TABLE [dbo].[GrupoSrv]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GS] [varchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GrupoSrv] ADD CONSTRAINT [PK_GrupoServ] PRIMARY KEY CLUSTERED  ([RucE], [Cd_GS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GrupoSrv] WITH NOCHECK ADD CONSTRAINT [FK_GrupoServ_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Corto', 'SCHEMA', N'dbo', 'TABLE', N'GrupoSrv', 'COLUMN', N'NCorto'
GO
