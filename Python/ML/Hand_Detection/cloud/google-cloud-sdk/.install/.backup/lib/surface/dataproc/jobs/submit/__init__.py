# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""The command group for submitting cloud dataproc jobs."""

from __future__ import absolute_import
from __future__ import unicode_literals
import argparse

from googlecloudsdk.calliope import base


class Submit(base.Group):
  """Submit Google Cloud Dataproc jobs to execute on a cluster.

  Submit Google Cloud Dataproc jobs to execute on a cluster.

  ## EXAMPLES

  To submit a Hadoop MapReduce job, run:

    $ {command} hadoop --cluster my_cluster --jar my_jar.jar arg1 arg2

  To submit a Spark Scala or Java job, run:

    $ {command} spark --cluster my_cluster --jar my_jar.jar arg1 arg2

  To submit a PySpark job, run:

    $ {command} pyspark --cluster my_cluster my_script.py arg1 arg2

  To submit a Spark SQL job, run:

    $ {command} spark-sql --cluster my_cluster --file my_queries.q

  To submit a Pig job, run:

    $ {command} pig --cluster my_cluster --file my_script.pig

  To submit a Hive job, run:

    $ {command} hive --cluster my_cluster --file my_queries.q
  """

  @staticmethod
  def Args(parser):
    # Allow user specified Job ID, but don't expose it.
    parser.add_argument(
        '--id', hidden=True, help='THIS ARGUMENT NEEDS HELP TEXT.')

    parser.add_argument(
        '--async',
        action='store_true',
        help='Does not wait for the job to run.')

    parser.add_argument(
        '--bucket',
        help=("The Cloud Storage bucket to stage files in. Defaults to the "
              "cluster's configured bucket."))
