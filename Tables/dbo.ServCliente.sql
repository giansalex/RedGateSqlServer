CREATE TABLE [dbo].[ServCliente]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[ID_ServClt] [int] NOT NULL,
[Cd_Srv] [char] (7) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Precio] [decimal] (13, 2) NOT NULL,
[IB_IncIGV] [bit] NOT NULL,
[Cd_Mda] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServCliente] ADD CONSTRAINT [PK_ServCliente] PRIMARY KEY CLUSTERED  ([RucE], [ID_ServClt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ServCliente] ADD CONSTRAINT [FK_ServCliente_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[ServCliente] ADD CONSTRAINT [FK_ServCliente_Servicio2] FOREIGN KEY ([RucE], [Cd_Srv]) REFERENCES [dbo].[Servicio2] ([RucE], [Cd_Srv])
GO
