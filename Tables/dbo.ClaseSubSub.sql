CREATE TABLE [dbo].[ClaseSubSub]
(
[RucE] [nvarchar] (11) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CL] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CLS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Cd_CLSS] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (6) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL,
[CA01] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL,
[CA02] [varchar] (100) COLLATE Modern_Spanish_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSubSub] ADD CONSTRAINT [PK_ClaseSubSub] PRIMARY KEY CLUSTERED  ([RucE], [Cd_CL], [Cd_CLS], [Cd_CLSS]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSubSub] ADD CONSTRAINT [IX_ClaseSubSub__Ruc_CdCL_CdCLS_Nom] UNIQUE NONCLUSTERED  ([RucE], [Cd_CL], [Cd_CLS], [Nombre]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ClaseSubSub] ADD CONSTRAINT [FK_ClaseSubSub_ClaseSub] FOREIGN KEY ([RucE], [Cd_CL], [Cd_CLS]) REFERENCES [dbo].[ClaseSub] ([RucE], [Cd_CL], [Cd_CLS])
GO
