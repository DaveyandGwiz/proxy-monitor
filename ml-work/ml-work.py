import pandas as pd
import numpy as np

# Assuming you have a CSV file named "data.csv" with columns 'Time' and 'CPU'

# Read the CSV file into a DataFrame
df = pd.read_csv('path/to/your/data.csv')  # Update the path to where your file is located

# Add a new column 'RAM' with random integer values between 1 and 100 for each row
df['RAM'] = np.random.randint(1, 101, df.shape[0])

# Add a new column 'Attack' where the value is 1 if CPU >= 2 and 0 otherwise
df['Attack'] = (df['CPU'] >= 2).astype(int)

# Save the modified DataFrame to a new CSV file
df.to_csv('path/to/your/new_csv.csv', index=False)  # Update the path as needed

# You can now use this new CSV file for your classifier






------
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from drf_yasg.utils import swagger_auto_schema
from drf_yasg import openapi

class EchoView(APIView):
    @swagger_auto_schema(
        operation_description="Echoes back the message query parameter",
        manual_parameters=[
            openapi.Parameter(
                'message', openapi.IN_QUERY,
                description="Message to echo back",
                type=openapi.TYPE_STRING
            )
        ]
    )
    def get(self, request, *args, **kwargs):
        message = request.query_params.get('message', 'No message provided')
        return Response({'message': message}, status=status.HTTP_200_OK)