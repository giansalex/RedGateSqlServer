CREATE TABLE [dbo].[Tasas]
(
[Cd_Ts] [nvarchar] (3) COLLATE Modern_Spanish_CI_AS NOT NULL,
[Nombre] [varchar] (50) COLLATE Modern_Spanish_CI_AS NOT NULL,
[NCorto] [varchar] (5) COLLATE Modern_Spanish_CI_AS NULL,
[Tasa] [numeric] (5, 2) NOT NULL,
[Estado] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tasas] ADD CONSTRAINT [PK_Tasas] PRIMARY KEY CLUSTERED  ([Cd_Ts]) ON [PRIMARY]
GO
