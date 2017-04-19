CREATE TABLE [dbo].[ListaPrecio_Area]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_LP] [char] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Area] ADD CONSTRAINT [PK_ListaPrecio_Area] PRIMARY KEY CLUSTERED  ([RucE], [Cd_LP], [Cd_Area]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ListaPrecio_Area] ADD CONSTRAINT [FK_ListaPrecio_Area_Area] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
ALTER TABLE [dbo].[ListaPrecio_Area] ADD CONSTRAINT [FK_ListaPrecio_Area_ListaPrecio] FOREIGN KEY ([RucE], [Cd_LP]) REFERENCES [dbo].[ListaPrecio] ([RucE], [Cd_LP])
GO
