CREATE TABLE [dbo].[ClaseSub]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CL] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CLS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSub] ADD CONSTRAINT [PK_ClaseSub] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CL], [Cd_CLS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSub] ADD CONSTRAINT [IX_ClaseSub__Ruc_CdCL_Nom] UNIQUE NONCLUSTERED  ([RucE], [Cd_CL], [Nombre]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSub] ADD CONSTRAINT [FK_ClaseSub_Clase] FOREIGN KEY ([RucE], [Cd_CL]) REFERENCES [dbo].[Clase] ([RucE], [Cd_CL])
GO
