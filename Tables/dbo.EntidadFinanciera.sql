CREATE TABLE [dbo].[EntidadFinanciera]
(
[Cd_EF] [char] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[CodSNT_] [varchar] (4) COLLATE Modern_Spanish_CI_AS NULL,
[Nombre] [varchar] (200) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EntidadFinanciera] ADD CONSTRAINT [PK_EntidadFinanciera] PRIMARY KEY CLUSTERED  ([Cd_EF]) ON [PRIMARY]
GO
