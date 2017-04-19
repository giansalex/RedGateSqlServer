CREATE TABLE [dbo].[Area]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_Area] [nvarchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Area] ADD CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED  ([RucE], [Cd_Area]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Area] WITH NOCHECK ADD CONSTRAINT [FK_Area_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nombre Corto', 'SCHEMA', N'dbo', 'TABLE', N'Area', 'COLUMN', N'NCorto'
GO
