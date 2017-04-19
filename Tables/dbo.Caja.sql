CREATE TABLE [dbo].[Caja]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Caja] [nvarchar] (10) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Numero] [nvarchar] (50) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Caja] ADD CONSTRAINT [PK_Caja_1] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Caja]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Caja] ADD CONSTRAINT [FK_Caja_Area1] FOREIGN KEY ([RucE], [Cd_Area]) REFERENCES [dbo].[Area] ([RucE], [Cd_Area])
GO
