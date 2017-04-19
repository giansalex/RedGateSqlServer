CREATE TABLE [dbo].[Clase]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CL] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clase] ADD CONSTRAINT [PK_Clase] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CL]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clase] ADD CONSTRAINT [IX_Clase__Ruc_Nom] UNIQUE NONCLUSTERED  ([RucE], [Nombre]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Clase] ADD CONSTRAINT [FK_Clase_Empresa] FOREIGN KEY ([RucE]) REFERENCES [dbo].[Empresa] ([Ruc])
GO
