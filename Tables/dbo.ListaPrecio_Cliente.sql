CREATE TABLE [dbo].[ListaPrecio_Cliente]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Clt] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Cliente] ADD CONSTRAINT [PK_ListaPrecio_Cliente] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP], [Cd_Clt]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Cliente] ADD CONSTRAINT [FK_ListaPrecio_Cliente_Cliente2] FOREIGN KEY ([RucE], [Cd_Clt]) REFERENCES [dbo].[Cliente2] ([RucE], [Cd_Clt])
GO
ALTER TABLE [dbo].[ListaPrecio_Cliente] ADD CONSTRAINT [FK_ListaPrecio_Cliente_ListaPrecio] FOREIGN KEY ([RucE], [Cd_LP]) REFERENCES [dbo].[ListaPrecio] ([RucE], [Cd_LP])
GO
