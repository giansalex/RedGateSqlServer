CREATE TABLE [dbo].[Servicio]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Srv] [nvarchar] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_GS] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[UsuCrea] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[UsuMdf] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[FecReg] [datetime] NOT NULL,
[FecMdf] [datetime] NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servicio] ADD CONSTRAINT [PK_Servicio] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Srv]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Servicio] WITH NOCHECK ADD CONSTRAINT [FK_Servicio_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
ALTER TABLE [dbo].[Servicio] WITH NOCHECK ADD CONSTRAINT [FK_Servicio_GrupoSrv] FOREIGN KEY ([RucE], [Cd_GS]) REFERENCES [dbo].[GrupoSrv] ([RucE], [Cd_GS])
GO
ALTER TABLE [dbo].[Servicio] WITH NOCHECK ADD CONSTRAINT [FK_Servicio_Producto] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Producto] ([RucE], [Cd_Pro]) ON UPDATE CASCADE
GO
