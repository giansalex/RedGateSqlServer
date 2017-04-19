CREATE TABLE [dbo].[MedioPago]
(
[Cd_TMP] [char] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Descrip] [varchar] (200) COLLATE Modern_Spanish_CI_AS NULL,
[NomCorto] [varchar] (10) COLLATE Modern_Spanish_CI_AS NULL,
[IC_IE] [char] (1) COLLATE Modern_Spanish_CI_AS NULL,
[Estado] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MedioPago] ADD CONSTRAINT [PK_MedioPago] PRIMARY KEY CLUSTERED  ([Cd_TMP]) ON [PRIMARY]
GO
