CREATE TABLE [dbo].[Modulo]
(
[Cd_MR] [nvarchar] (2) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Ncorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Modulo] ADD CONSTRAINT [PK_Modulo] PRIMARY KEY CLUSTERED  ([Cd_MR]) ON [PRIMARY]
GO
